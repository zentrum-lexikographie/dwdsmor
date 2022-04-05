(ns dwdsmor.lexicon
  "DWDSmor lexicon generation."
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.tools.cli :refer [parse-opts]]
            [clojure.tools.logging :as log]
            [com.climate.claypoole :as cp]
            [com.climate.claypoole.lazy :as cpl]
            [dwdsmor.smorlemma :as smorlemma])
  (:import [ch.qos.logback.classic Level Logger]
           java.io.File
           java.text.Collator
           java.time.Duration
           java.util.Locale
           javax.xml.transform.stream.StreamSource
           net.sf.saxon.Configuration
           net.sf.saxon.lib.ErrorReporter
           [net.sf.saxon.s9api MessageListener2 Processor SaxonApiException XdmDestination XdmNode XsltCompiler XsltExecutable]
           org.slf4j.LoggerFactory))

;; ## XSLT/Saxon-HE
;;
;; We use [Saxon-HE](https://www.saxonica.com/) as a runtime environment for
;; the XSLT-2.0-based extraction logic.

(def ^Processor saxon-processor
  (Processor. (Configuration.)))

(def ^XsltCompiler saxon-xslt-compiler
  (.newXsltCompiler saxon-processor))

(defn ^XsltExecutable compile-xslt
  [file-path]
  (.compile saxon-xslt-compiler (StreamSource. file-path)))

(def xslt-message-listener
  "Suppress error reporting on System/err and divert XSLT messages to the logger."
  (proxy [ErrorReporter MessageListener2] []
    (report [_])
    (message [^XdmNode content _ _ _]
      (let [msg (.getStringValue content)]
        (if (str/starts-with? msg "Error: ")
          (log/error (str/replace-first msg #"Error: " ""))
          (if (str/starts-with? msg "Warning: ")
            (log/warn (str/replace-first msg #"Warning: " ""))
            (log/debug msg)))))))

(defn xslt-fn
  "Derive XSLT transformers from compiled stylesheet."
  [{{:keys [^File xslt]} :options}]
  (let [^XsltExecutable xslt (.compile saxon-xslt-compiler (StreamSource. xslt))]
    (fn [^File article]
      (try
        (let [file-name   (.getName article)
              destination (XdmDestination.)
              transformer (doto (.load30 xslt)
                            (.setMessageListener xslt-message-listener)
                            (.setErrorReporter xslt-message-listener))
              _           (.. transformer
                              (transform (StreamSource. article) destination))
              entries     (.. destination (getXdmNode) (getStringValue))
              entries     (map str/trim (str/split-lines entries))]
          (doseq [entry entries]
            (if (str/blank? entry)
              (log/debugf "%s: EMPTY" file-name)
              (log/debugf "%s: %s" file-name entry)))
          (remove str/blank? entries))
        (catch SaxonApiException e
          (log/warnf
           "XSLT error :: %s: %s " (.getPath article) (.getMessage e)))))))

;; ## Command Line Interface

(def cli-options
  [["-x" "--xslt XSLT"
    :desc "XSLT stylesheet"
    :parse-fn io/file]
   ["-o" "--output OUTPUT"
    :desc "Path of the generated lexicon"
    :parse-fn io/file]
   ["-s" "--smorlemma-lexica"
    :desc "Include additional lexica from SMORLemma"]
   ["-f" "--filter"
    :desc "Filter entries with tag <UNKNOWN>"]
   ["-l" "--limit MAX_ENTRIES"
    :desc "Limit the number of extracted lexicon entries for testing"
    :parse-fn #(Integer/parseInt %)
    :validate [pos? "Limit has to be > 0"]]
   ["-d" "--debug"
    :desc "Print debugging information"]
   ["-h" "--help"]])

(defn usage
  [{:keys [summary]}]
  (str/join
   \newline
   ["DWDSmor Lexicon Generation"
    ""
    "Copyright (C) 2022 Berlin-Brandenburgische Akademie der Wissenschaften"
    ""
    "Usage: clojure -M -m dwdsmor.lexicon [options] <dir|*.xml>..."
    ""
    "Generates a DWDSmor lexicon from (directories of) XML documents in the DWDS format."
    ""
    "Options:"
    summary
    ""]))

(defn error-msg
  [errors opts]
  (str "The following errors occurred while parsing your command:\n\n"
       (str/join \newline (conj errors "" (usage opts)))))

(defn exit
  ([status]
   (System/exit status))
  ([status msg]
   (println msg)
   (System/exit status)))

(defn parse-args
  "Parses command line arguments and checks for required parameters."
  [args]
  (let [{:keys [options errors] :as opts} (parse-opts args cli-options)
        {:keys [xslt output]}             options]
    (cond
      (:help options) (exit 0 (usage opts))
      (seq errors)    (exit 1 (error-msg errors opts))
      (nil? xslt)     (exit 1 (error-msg ["No XSLT stylesheet specified."] opts))
      (nil? output)   (exit 1 (error-msg ["No output file specified."] opts)))
    opts))

;; ## Input file handling
;;
;; Input files are provided as paths to individual files or directory paths,
;; which are recursively scanned for descendant files with `.xml` extension.

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
  (sort (mapcat file->xml-docs (map io/file files))))


(def sort-key
  "Output (lexicon entries) is sorted according to German locale and case
  insensitive."
  (let [collator (doto (Collator/getInstance Locale/GERMAN)
                   (.setStrength Collator/IDENTICAL))]
    (fn [s] (.getCollationKey collator s))))

(defn configure-logging!
  "Translates `--debug` CLI option into DEBUG-level logging."
  [{{:keys [debug]} :options}]
  (let [^Logger logger (LoggerFactory/getLogger "dwdsmor")]
    (when debug
      (.setLevel logger Level/DEBUG))))

(defn -main
  [& args]
  (let [start (System/currentTimeMillis)
        args  (parse-args args)]
    (configure-logging! args)
    (try
      (let [articles (article-files args)
            _        (log/infof "Extracting lexicon entries from %d file(s)"
                                (count articles))
            xslt     (xslt-fn args)
            entries  (apply concat (cpl/upmap (cp/ncpus) xslt articles))
            limit    (get-in args [:options :limit])
            filter?  (get-in args [:options :filter])
            entries  (vec (cond->> entries
                            filter? (remove #(re-seq #"<UNKNOWN>" %))
                            limit   (take limit)))
            _        (log/info "Sorting lexicon entries and removing duplicates")
            entries  (dedupe (sort-by sort-key entries))
            entries  (concat
                      (when (get-in args [:options :smorlemma-lexica])
                        (log/info "Prepending SMORLemma lexica")
                        smorlemma/lexicon)
                      entries)
            _        (log/info "Writing lexicon entries")
            output   (get-in args [:options :output])]
        (with-open [w (io/writer output :encoding "UTF-8")]
          (doseq [chunk (concat (interpose "\n" entries) '("\n"))] (.write w chunk))))
      (let [stop     (System/currentTimeMillis)
            duration (Duration/ofMillis (- stop start))]
        (log/infof "Generated lexicon in %s" duration))
      (catch Throwable t
        (log/error t "Error while generating lexicon")
        (exit 4)))))
