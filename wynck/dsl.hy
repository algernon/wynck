(import [wnck]
        [re]
        [adderall.dsl [*]])
(require adderall.dsl)

;; 
;; Workspaces

(defn-alias [workspaceᵒ workspaceo] [w]
  (memberᵒ w (.get-workspaces (wnck.screen-get-default))))

(defn-alias [workspace/numberᵒ workspace/numbero] [wspc n]
  (project [wspc]
           (≡ (.get-number wspc) n)))

(defn-alias [workspace/nameᵒ workspace/nameo] [wspc name]
  (project [wspc]
           (if (.match (re.compile name) (.get-name wspc))
             #ss
             #uu)))

;; 
;; Windows

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

(defmacro/g! defmatch [names step-1 step-2]
  `(defn-alias ~names [~g!w ~g!r]
     (project [~g!w]
              (if (.match (re.compile ~g!r)
                          (-> (~step-1 ~g!w)
                              ~step-2))
                #ss
                #uu))))

(defmatch [application/nameᵒ application/nameo]
  .get-application
  .get-name)
