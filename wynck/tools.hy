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

(defn window/ensure [w what s options]
  (when s
    (setv w (substitute w s))
    (setv what (substitute what s)))

  (cond
   [(nil? s) s]
   [(instance? wnck.Workspace what)
    (do
     (.move-to-workspace w what)
     s)]
   [(= what :maximized)
    (do
     (if (or (empty? options)
             (first options))
       (.maximize w)
       (.unmaximize w))
     s)]
   [(= what :unmaximized)
    (do
     (if (or (empty? options)
             (first options))
       (.unmaximize w)
       (.maximize w))
     s)]
   [(= what :position)
    (let [[[x y] options]]
      (.set-geometry w
                     wnck.WINDOW_GRAVITY_STATIC
                     (| wnck.WINDOW_CHANGE_X
                        wnck.WINDOW_CHANGE_Y)
                     x y 0 0)
      s)]))
