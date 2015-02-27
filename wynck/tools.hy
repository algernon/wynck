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
        [adderall.internal [substitute]])

;;
;; Windows
;;

(defn window/ensure [w what s]
  (when s
    (setv w (substitute w s))
    (setv what (substitute what s)))

  (cond
   [(nil? s) s]
   [(instance? wnck.Workspace what)
    (do
     (.move-to-workspace w what)
     s)]))
