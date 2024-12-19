(ns aoc24 
  (:require
   [clojure.java.io :as io]
   [clojure.string :as string]))

(defn ^:export part1 [file-name]
  (->> (io/reader file-name)
       line-seq
       (map #(map parse-long (string/split % #"\s+")))
       (apply map (comp sort vector))
       (apply map (comp abs -))
       (reduce + 0)))

(comment
  (part1 "example.txt")
  (part1 "input.txt"))

(defn ^:export part2 [file-name]
  (let [[l1 l2] (->> (io/reader file-name)
                    line-seq
                    (map #(map parse-long (string/split % #"\s+")))
                    (apply map vector))
        counts (frequencies l2)]
   (reduce + 0 (map #(* % (get counts % 0)) l1))))

(defn ^:export part2-cli [args]
  (println (part2 (:input args))))
(comment

  (def file-name "example.txt")
  (part2 "example.txt")
  (part2 "input.txt"))
