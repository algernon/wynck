(import [wnck]
        [re]
        [adderall.dsl [*]]
        [hy [HySymbol HyExpression]])
(require adderall.dsl)

;;
;; Helpers
;;

(defmacro/g! defmatchers [prefix properties]
  (HyExpression
   (+ ['do]
      (list-comp
       (let [[unicode-name (HySymbol (+ prefix "/" x "ᵒ"))]
             [ascii-name (HySymbol (+ prefix "/" x "o"))]
             [accessor (HySymbol (+ ".get_" x))]]
         `(defn-alias [~unicode-name ~ascii-name] [~g!o ~g!r]
            (project [~g!o]
                     (fn [~g!s]
                       (let [[~g!rr (reify ~g!r ~g!s)]]
                         (if (lvar? ~g!rr)
                           ((== (~accessor ~g!o) ~g!r) ~g!s)
                           (if (.match (re.compile ~g!r)
                                       (~accessor ~g!o))
                             #ss
                             #uu)))))))
       [x properties]))))

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

;;
;; Workspaces
;;

(defn-alias [workspaceᵒ workspaceo] [w]
  (memberᵒ w (.get-workspaces (wnck.screen-get-default))))

(defaccessors workspace [number])

(defmatchers workspace [name])

;;
;; Windows
;;

(defn-alias [windowᵒ windowo] [w]
  (memberᵒ w (.get-windows (wnck.screen-get-default))))

(defn-alias [window/workspaceᵒ window/workspaceo] [w wspc]
  (project [w]
           (fn [s]
             (let [[ws (reify wspc s)]]
               (if (lvar? ws)
                 ((== (.get-workspace w) wspc) s)
                 (do
                  (.move-to-workspace w ws)
                  (succeed s)))))))

(defn-alias [window/geometryᵒ window/geometryo] [win geom]
  (project [win]
           (fn [s]
             (let [[rgeom (reify geom s)]]
               (if (lvar? rgeom)
                 ((== (.get-geometry win) geom) s)
                 (let [[[x y w h] rgeom]]
                   (.set-geometry win
                                  wnck.WINDOW_GRAVITY_STATIC
                                  (| wnck.WINDOW_CHANGE_Y
                                     wnck.WINDOW_CHANGE_X
                                     wnck.WINDOW_CHANGE_WIDTH
                                     wnck.WINDOW_CHANGE_HEIGHT)
                                  x y w h)
                   (succeed s)))))))

(defn-alias [window/positionᵒ window/positiono] [win pos]
  (project [win]
           (fn [s]
             (let [[rpos (reify pos s)]]
               (if (lvar? rpos)
                 ((fresh [geom f r s]
                         (== (.get-geometry win) geom)
                         (firsto geom f)
                         (resto geom r)
                         (firsto r s)
                         (== pos [f s])) s)
                 (let [[[x y] rpos]]
                   (.set-geometry win
                                  wnck.WINDOW_GRAVITY_STATIC
                                  (| wnck.WINDOW_CHANGE_Y
                                  wnck.WINDOW_CHANGE_X)
                                  x y 0 0)
                   (succeed s)))))))

(defmatchers window [name])

(defaccessors window [application class-group group-leader xid])

;;
;; Applications
;;

(defmatchers application [name])

(defaccessors application [windows])
