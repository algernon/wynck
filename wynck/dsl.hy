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
        [wynck.internal.tools]
        [gobject]
        [wynck.internal.unify]
        [gtk.gdk [display-get-default]]
        [adderall.dsl [*]])
(require wynck.internal.unify)
(require adderall.dsl)

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
    (yield (wynck.internal.tools.window/ensure w what s options))))

(defn-alias [applicationᵒ applicationo] [a]
  (memberᵒ a (set (list-comp (.get-application w)
                             [w (.get-windows (wnck.screen_get_default))]))))


;;;

(defmacro trace [vars &rest rules]
  `(project ~vars
            (do
             ~@rules
             #ss)))

;;;

(defmacro/g! wynck [user-data &rest rules]
  `(do
    (for [~g!n (range (.get-n-screens (display-get-default)))]
      (let [[screen (wnck.screen-get ~g!n)]]
        (.force-update screen)
        (setv screen.unify wynck.internal.unify.screen)
        (for [cw (.get-windows screen)]
          (setv cw.unify wynck.internal.unify.window))
        (for [cws (.get-workspaces screen)]
          (setv cws.unify wynck.internal.unify.workspace))
        (for [app (set (list-comp (.get-application w)
                                  [w (.get-windows screen)]))]
          (setv app.unify wynck.internal.unify.application))
        (.connect screen "window-opened"
                  (fn [screen window data]
                    (setv screen.unify wynck.internal.unify.screen)
                    (setv window.unify wynck.internal.unify.window)
                    (let [[ws (.get-workspace window)]
                          [app (.get-application window)]]
                      (setv ws.unify wynck.internal.unify.workspace)
                      (setv app.unify wynck.internal.unify.application))
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

;;

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

(defmacro activate []
  `(≡ ?activate true))

(defmacro wynck/simple [&rest rules]
  `(wynck nil
          ~@rules

          (window/ensureᵍ window ?workspace)
          (condᵉ
           [(≡ ?activate true)
            (window/ensureᵍ window :activate)])))
