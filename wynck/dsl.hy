(import [wnck]
        [re]
        [adderall.dsl [*]])
(require adderall.dsl)

;;
;; Helpers
;;

(defmacro/g! defmatch [names extractor]
  `(defn-alias ~names [~g!w ~g!r]
     (project [~g!w]
              (if (.match (re.compile ~g!r)
                          (~extractor ~g!w))
                #ss
                #uu))))

;;
;; Workspaces
;;

(defn-alias [workspaceᵒ workspaceo] [w]
  (memberᵒ w (.get-workspaces (wnck.screen-get-default))))

(defn-alias [workspace/numberᵒ workspace/numbero] [wspc n]
  (project [wspc]
           (≡ (.get-number wspc) n)))

(defmatch [workspace/nameᵒ workspace/nameo]
  .get-name)

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

(defmatch [window/applicationᵒ window/applicationo]
  .get-application)

(defmatch [window/class-groupᵒ window/class-groupo]
  .get-class-group)

(defmatch [window/nameᵒ window/nameo]
  .get-name)

(defmatch [window/group-leaderᵒ window/group-leadero]
  .get-group-leader)

(defmatch [window/xidᵒ window/xido]
  .get-xid)

;;
;; Applications
;;

(defmatch [application/nameᵒ application/nameo]
  .get-name)

(defmatch [application/windowsᵒ application/windowso]
  .get-windows)
