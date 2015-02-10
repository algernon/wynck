(import [gtk.gdk [display-get-default]]
        [wnck]
        [gobject]
        [wynck.dsl [*]]
        [adderall.dsl [*]])
(require adderall.dsl)

(defmacro/g! wynck [user-data &rest rules]
  `(do
    (for [~g!n (range (.get-n-screens (display-get-default)))]
        (let [[~g!scr (wnck.screen-get ~g!n)]]
          (.connect ~g!scr "window-opened"
                    (fn [~g!s ~g!w ~g!d]
                      (run* [screen window data]
                            (== screen ~g!s)
                            (== window ~g!w)
                            (== data ~g!d)
                            (prep
                             ~@rules)))
                    ~user-data)))
    (.run (gobject.MainLoop))))

(defmacro trace [vars &rest rules]
  `(project ~vars
            (do
             ~@rules
             #ss)))
