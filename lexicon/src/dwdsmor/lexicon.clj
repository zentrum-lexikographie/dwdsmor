(ns dwdsmor.lexicon
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.tools.logging :as log]
            [com.climate.claypoole :as cp]
            [com.climate.claypoole.lazy :as cpl])
  (:import [ch.qos.logback.classic Level Logger]
           java.io.File
           java.text.Collator
           java.util.Locale
           javax.xml.transform.stream.StreamSource
           net.sf.saxon.Configuration
           [net.sf.saxon.s9api MessageListener2 Processor SaxonApiException XdmDestination XdmNode XsltCompiler XsltExecutable]
           org.slf4j.LoggerFactory))

(def ^Processor saxon-processor
  (Processor. (Configuration.)))

(def ^XsltCompiler saxon-xslt-compiler
  (.newXsltCompiler saxon-processor))

(defn compile-xslt
  [s]
  (.compile saxon-xslt-compiler (StreamSource. s)))

(def cli-options
  [["-x" "--xslt XSLT"
    :desc "XSLT stylesheet extracting lexicon entries from DWDS article files"
    :parse-fn io/file]
   ["-o" "--output OUTPUT"
    :desc "Path of the file the generated lexicon is written to"
    :parse-fn io/file]
   ["-d" "--debug"
    :desc "Print debugging information"]
   ["-h" "--help"]])

(defn usage
  [{:keys [summary]}]
  (str/join
   \newline
   ["DWDSmor Lexicon Generation"
    "Copyright (C) 2021 Berlin-Brandenburgische Akademie der Wissenschaften"
    ""
    "Usage: clojure -M -m dwdsmor.lexicon [options] <dir|*.xml>..."
    ""
    "Generates a lexicon from the given XML documents and/or directories "
    "containing XML documents (files ending in .xml)."
    ""
    "Options:"
    summary
    ""]))

(defn error-msg
  [{:keys [errors] :as opts}]
  (str "The following errors occurred while parsing your command:\n\n"
       (str/join \newline (conj errors "" (usage opts)))))

(defn exit
  ([status]
   (System/exit status))
  ([status msg]
   (log/error msg)
   (System/exit status)))

(defn parse-args
  [args]
  (let [{:keys [options errors] :as opts} (parse-opts args cli-options)
        {:keys [xslt output]}             options]
    (cond
      (:help options) (exit 0 (usage opts))
      (seq errors)    (exit 1 (error-msg opts))
      (nil? xslt)     (exit 1 "No XSLT stylesheet specified")
      (nil? output)   (exit 1 "No output file specified"))
    opts))

(defn configure-logging!
  [{{:keys [debug]} :options}]
  (let [^Logger logger (LoggerFactory/getLogger "dwdsmor")]
    (when debug
      (.setLevel logger Level/DEBUG))))

(defn xml-file?
  [^File f]
  (and
   (.isFile f)
   (-> (.getName f) (str/lower-case) (str/ends-with? ".xml"))))

(defn file->xml-docs
  [^File f]
  (cond
    (.isFile f)      [f]
    (.isDirectory f) (filter xml-file? (file-seq f))
    :else            (exit 2 (str (str f) " does not exist"))))

(defn article-files
  [{files :arguments}]
  (mapcat file->xml-docs (map io/file files)))

(def xslt-message-listener
  (proxy [MessageListener2] []
    (message [^XdmNode content _ _ _]
      (log/debug (.getStringValue content)))))

(defn xslt-fn
  [{{:keys [^File xslt]} :options}]
  (let [^XsltExecutable xslt (.compile saxon-xslt-compiler (StreamSource. xslt))]
    (fn [^File article]
      (log/debugf "< %s" (.getPath article))
      (try
        (let [destination (XdmDestination.)
              transformer (doto (.load30 xslt)
                            (.setMessageListener xslt-message-listener))
              _           (.. transformer
                              (transform (StreamSource. article) destination))
              entries     (.. destination (getXdmNode) (getStringValue))
              entries     (map str/trim (str/split-lines entries))]
          (doseq [entry entries] (log/debugf "> %s" entry))
          entries)
        (catch SaxonApiException e
          (log/errorf e "XSLT error while processing %s" (.getPath article)))))))

(def sort-key
  (let [collator (doto (Collator/getInstance Locale/GERMAN)
                   (.setStrength Collator/PRIMARY))]
    (fn [s] (.getCollationKey collator s))))

(defn -main
  [& args]
  (let [args     (parse-args args)]
    (configure-logging! args)
    (try
      (let [articles (article-files args)
            xslt     (xslt-fn args)
            _        (log/info "Extracting lexicon entries")
            entries  (vec (apply concat (cpl/upmap (cp/ncpus) xslt articles)))
            _        (log/info "Sorting lexicon entries")
            entries  (sort-by sort-key entries)
            _        (log/info "Writing lexicon entries")
            output   (get-in args [:options :output])]
        (with-open [w (io/writer output :encoding "UTF-8")]
          (doseq [chunk (interpose "\n" entries)] (.write w chunk))))
      (catch Throwable t
        (log/error t "Error while generating lexicon")
        (exit 4)))))
