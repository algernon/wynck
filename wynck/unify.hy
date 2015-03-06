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

(import [wnck]
        [re]
        [adderall.dsl [*]]
        [adderall.internal [extend extend-unchecked substitute]])
(require adderall.dsl)

(def --re-type-- (type (re.compile "")))

(defmacro/g! defaccessors [prefix properties]
  (HyExpression
   (+ ['do]
      (list-comp
       (let [[unicode-name (HySymbol (+ prefix "/" x "ᵒ"))]
             [ascii-name (HySymbol (+ prefix "/" x "o"))]
             [accessor (HySymbol (+ ".get_" x))]]
         `(defn-alias [~unicode-name ~ascii-name] [~g!o ~g!v]
            (project [~g!o]
                     (== (~accessor ~g!o) ~g!v))))
       [x properties]))))

(defn workspace [u v s]
  (when s
    (setv u (substitute u s))
    (setv v (substitute v s)))

  (cond
   [(lvar? u)
    (if (lvar? v)
      (extend-unchecked u v s)
      (extend u v s))]
   [(lvar? v)
    (extend v u s)]
   [(integer? v)
    (when (and (instance? wnck.Workspace u)
               (= (.get-number u) v))
      (, v (.get-number u) s))]
   [(string? v)
    (when (and (instance? wnck.Workspace u)
               (= (.get-name u) v))
      (, v (.get-name u) s))]
   [(integer? u)
    (when (and (instance? wnck.Workspace v)
               (= (.get-number v) u))
      (, u (.get-number v) s))]
   [(string? u)
    (when (and (instance? wnck.Workspace v)
               (= (.get-name v) u))
      (, u (.get-name v) s))]))

(defn window [u v s]
  (when s
    (setv u (substitute u s))
    (setv v (substitute v s)))

  (cond
   [(nil? s) s]
   [(is u v) s]
   [(lvar? v)
    (when (instance? wnck.Window u)
      (, v u s))]
   [(lvar? u)
    (when (instance? wnck.Window v)
      (, u v s))]
   [(string? v)
    (when (and (instance? wnck.Window u)
               (= (.get-name u) v))
      (, v (.get-name u) s))]
   [(string? u)
    (when (and (instance? wnck.Window v)
               (= (.get-name v) u))
      (, u (.get-name v) s))]
   [(instance? --re-type-- v)
    (when (and (instance? wnck.Window u)
               (.match v (.get-name u)))
      (, v (.get-name u) s))]
   [(instance? --re-type-- u)
    (when (and (instance? wnck.Window v)
               (.match u (.get-name v)))
      (, u (.get-name v) s))]
   [(integer? v)
    (when (and (instance? wnck.Window u)
               (= (.get-xid u) v))
      (, v (.get-xid u) s))]
   [(integer? u)
    (when (and (instance? wnck.Window v)
               (= (.get-xid v) u))
      (, u (.get-xid v) s))]))

(defn application [u v s]
  (when s
    (setv u (substitute u s))
    (setv v (substitute v s)))

  (cond
   [(nil? s) s]
   [(is u v) s]
   [(lvar? v)
    (when (instance? wnck.Application u)
      (, v u s))]
   [(lvar? u)
    (when (instance? wnck.Application v)
      (, u v s))]
   [(string? v)
    (when (and (instance? wnck.Application u)
               (= (.get-name u) v))
      (, v (.get-name u) s))]
   [(string? u)
    (when (and (instance? wnck.Application v)
               (= (.get-name v) u))
      (, u (.get-name v) s))]
   [(instance? --re-type-- v)
    (when (and (instance? wnck.Application u)
               (.match v (.get-name u)))
      (, v (.get-name u) s))]
   [(instance? --re-type-- u)
    (when (and (instance? wnck.Application v)
               (.match u (.get-name v)))
      (, u (.get-name v) s))]))

(defn screen [u v s]
  (when s
    (setv u (substitute u s))
    (setv v (substitute v s)))

  (cond
   [(lvar? u)
    (if (lvar? v)
      (extend-unchecked u v s)
      (extend u v s))]
   [(lvar? v)
    (extend v u s)]
   [(integer? v)
    (when (and (instance? wnck.Screen u)
               (= (.get-number u) v))
      (, v (.get-number u) s))]
   [(integer? u)
    (when (and (instance? wnck.Screen v)
               (= (.get-number v) u))
      (, u (.get-number v) s))]))
