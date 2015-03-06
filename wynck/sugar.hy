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

(defmacro => [window &rest rules]
  `[(≃ window ~(--rewrite-simple-symbol-- window))
    ~@rules])

(defmacro ? [&rest rules]
  `(condᵉ
    ~@rules))

(defmacro maximized []
  `(window/ensureᵍ window :maximized))

(defmacro unmaximized []
  `(window/ensureᵍ window :unmaximized))

(defmacro workspace [ws]
  `(≡ ?workspace ~ws))

(defmacro position [x y]
  `(window/ensureᵍ window :position ~x ~y))

(defmacro vscreen [place]
  `(window/ensureᵍ window :vscreen ~place))

(defmacro wynck/simple [&rest rules]
  `(wynck nil
          ~@rules

          (window/ensureᵍ window ?workspace)))
