;; wynck – wnck on adderall
;; Copyright (C) 2015  Gergely Nagy <algernon@madhouse-project.org>
;;
;; This library is free software: you can redistribute it and/or
;; modify it under the terms of the GNU Lesser General Public License
;; as published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.
;;
;; This library is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; Lesser General Public License for more details.
;;
;; You should have received a copy of the GNU Lesser General Public
;; License along with this program. If not, see <http://www.gnu.org/licenses/>.

(import [wynck.dsl [*]]
        [adderall.dsl [*]]
        [re])
(require adderall.dsl)

(defn-alias [≃ =~] [u v]
  (prep
   (condᵉ
    [(window/applicationᵒ u ?app)
     (≡ ?app v)]
    (else (≡ u v)))))

(defn --rewrite-simple-symbol-- [sym]
  (if (keyword? sym)
    `~(HyString (name sym))
    `(re.compile ~sym)))

(defn --rewrite-options-- [options]
  (map (fn [o]
         (cond
          [(= o '+)
           `(window/ensureᵍ window :maximized)]
          [(= o '-)
           `(window/ensureᵍ window :unmaximized)]
          [(integer? o)
           `(≡ ?workspace ~(HyInteger (dec o)))]
          [(coll? o)
           `(window/ensureᵍ window :position ~(first o) ~(second o))]))
       options))

(defn --rewrite-simple-- [s]
  (let [[[op what] (slice s 0 2)]]
    (cond
     [(= op '=>)
      `[(≃ window ~(--rewrite-simple-symbol-- what))
        ~@(--rewrite-options-- (slice s 2))]])))

(defmacro wynck/simple [&rest rules]
  `(wynck nil
          (condᵉ
           ~@(map (fn [s]
                    (if (= (first s) 'else)
                      s
                      `~(--rewrite-simple-- s)))
                  rules))

          (window/ensureᵍ window ?workspace)))
