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
                     (if (.match (re.compile ~g!r)
                                 (~accessor ~g!o))
                       #ss
                       #uu))))
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
                     (≡ (~accessor ~g!o) ~g!v))))
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

(defmatchers window [name])

(defaccessors window [application class-group group-leader xid])

;;
;; Applications
;;

(defmatchers application [name])

(defaccessors application [windows])
