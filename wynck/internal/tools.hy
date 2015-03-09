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
        [gtk.gdk]
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
   [(= what :vscreen)
    (let [[[x y a b] (.get-geometry w)]
           [width (int (/ (-> w .get-workspace .get-width) 2))]]
       (if (and (= (first options) :left)
                (> x width))
         (setv x (- x width)))
       (if (and (= (first options) :right)
                (< x width))
         (setv x (+ x width)))
       (window/ensure w :position s [x y]))]
   [(= what :activate)
    (let [[now (gtk.gdk.x11_get_server_time
                (gtk.gdk.get_default_root_window))]]
      (.activate w now))]
   [(= what :position)
    (let [[[x y] options]]
      (.set-geometry w
                     wnck.WINDOW_GRAVITY_STATIC
                     (| wnck.WINDOW_CHANGE_X
                        wnck.WINDOW_CHANGE_Y)
                     x y 0 0)
      s)]))
