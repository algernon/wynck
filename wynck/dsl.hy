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

(import [adderall.dsl [*]]
        [wnck]
        [wynck.tools]
        [gtk.gdk [display-get-default]])
(require wynck.unify)

(defn-alias [screenᵒ screeno] [s]
  (memberᵒ s (list-comp (wnck.screen-get x)
                        [x (range (.get-n-screens (display-get-default)))])))

(defn-alias [workspaceᵒ workspaceo] [w]
  (memberᵒ w (.get-workspaces (wnck.screen-get-default))))

(defn-alias [windowᵒ windowo] [w]
  (memberᵒ w (.get-windows (wnck.screen-get-default))))

(defaccessors window [application workspace class-group group-leader
                      screen])

(defn-alias [window/ensureᵍ window/ensureg] [w what &rest options]
  (fn [s]
    (yield (wynck.tools.window/ensure w what s options))))

(defn-alias [applicationᵒ applicationo] [a]
  (memberᵒ a (set (list-comp (.get-application w)
                             [w (.get-windows (wnck.screen_get_default))]))))
