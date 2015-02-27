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

(import [gtk.gdk [display-get-default]]
        [wnck]
        [gobject]
        [wynck.unify])

(defmacro/g! wynck [user-data &rest rules]
  `(do
    (for [~g!n (range (.get-n-screens (display-get-default)))]
      (let [[~g!scr (wnck.screen-get ~g!n)]]
        (.force-update ~g!scr)
        (for [cw (.get-windows ~g!scr)]
          (setv cw.unify wynck.unify.window))
        (for [cws (.get-workspaces ~g!scr)]
          (setv cws.unify wynck.unify.workspace))
        (for [app (set (list-comp (.get-application w)
                                  [w (.get-windows
                                      (wnck.screen_get_default))]))]
          (setv app.unify wynck.unify.application))
        (.connect ~g!scr "window-opened"
                  (fn [screen window data]
                    (setv window.unify wynck.unify.window)
                    (let [[ws (.get-workspace window)]
                          [app (.get-application window)]]
                      (setv ws.unify wynck.unify.workspace)
                      (setv app.unify wynck.unify.application))
                    (run* [q]
                          (prep
                           (workspaceᵒ ?workspace)
                           (applicationᵒ ?application)
                           ~@rules)
                          (≡ q true))
                    true)
                  ~user-data)
        nil))
    (.run (gobject.MainLoop))))

(defmacro trace [vars &rest rules]
  `(project ~vars
            (do
             ~@rules
             #ss)))
