(ns dwdsmor.smorlemma
  "Additional lexicon entries from SMORLemma."
  (:require [clojure.data.xml :as dx]
            [clojure.data.zip.xml :as zx]
            [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.zip :as zip]))

(defn remove-comment
  [line]
  (str/trim (str/replace line #"%.*$" "")))

(defn lexicon-entries
  [file]
  (let [content (slurp file :encoding "UTF-8")
        lines   (str/split-lines content)
        lines   (map remove-comment lines)
        lines   (filter not-empty lines)]
    lines))

(def tag-re
  #"<[^<>]+>")

(def lexicon-dir
  (io/file ".." "SMORLemma" "lexicon"))

(def sublexica
  {(io/file lexicon-dir "adj.irreg.lex")          "<ADJ>"
   (io/file lexicon-dir "adpositions.closed.lex") "<OTHER>"
   ;; (io/file lexicon-dir "verbs.irreg.lex")        "<V>"
   (io/file lexicon-dir "adv.irreg.lex")          "<ADV>"})

(def sublexicon-entries
  "Peter Adolph's sublexica."
  (for [[file pos] sublexica
        line       (lexicon-entries file)]
    (let [contents (filter not-empty (str/split line tag-re))
          tags     (re-seq tag-re line)
          tag-set  (apply hash-set tags)
          stem     (first contents)
          stem     (str (when (tag-set "<ge>") "<ge>") stem)
          orth     (cond
                     (tag-set "<OLDORTH>") "<OLDORTH>"
                     (tag-set "<NEWORTH>") "<NEWORTH>"
                     :else                 "")
          tags     (remove #{"<OLDORTH>" "<NEWORTH>"} tags)]
      (str "<Stem>" stem orth pos "<base><nativ>" (last tags)))))

(def affix-lexicon
  "Detachable verb prefixes can also stand on its own (add lexical entry)"
  (let [affixes (lexicon-entries (io/file lexicon-dir "affix.lex"))]
    (concat
     affixes
     (for [detachable (filter #(str/includes? % "<PREF><V>") affixes)]
       (let [contents (filter not-empty (str/split detachable tag-re))
             stem     (first contents)
             tags     (re-seq tag-re detachable)
             origin   (last tags)]
         (str "<Stem>" stem "<OTHER><base>" origin "<Pref/Sep>"))))))

(defn wrap-tag
  [tag]
  (str "<" tag ">"))

(defn align
  [lemma stem]
  (let [lemma-n (count lemma)
        stem-n  (count stem)
        length  (max lemma-n stem-n)
        lemma   (concat lemma (repeat (- length lemma-n) nil))
        stem    (concat stem (repeat (- length stem-n) nil))]
    (apply
     str
     (mapv
      (fn [c1 c2] (if (= c1 c2) c1 (str (or c1 "<>") ":" (or c2 "<>"))))
      lemma stem))))

(defn morphisto-xml-entries
  [file]
  (with-open [input (io/input-stream file)]
    (let [doc (zip/xml-zip (dx/parse input))]
      (for [entry (zx/xml-> doc :smor :BaseStem)]
        (str "<Stem>"
             (zx/xml1-> entry :MorphMarker zx/text wrap-tag)
             (align (zx/xml1-> entry :Lemma zx/text)
                    (zx/xml1-> entry :Stem zx/text))
             (zx/xml1-> entry :Pos zx/text wrap-tag)
             "<base>"
             (zx/xml1-> entry :Origin zx/text wrap-tag)
             (zx/xml1-> entry :InfClass zx/text wrap-tag))))))

(def irregular-nouns
  (morphisto-xml-entries (io/file lexicon-dir "nouns.irreg.xml")))

(def lexicon
  (concat sublexicon-entries affix-lexicon irregular-nouns))

(comment (count lexicon))
