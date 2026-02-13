;; GrantDAO Clarity Contract
;; DAO-based grant distribution system.


(define-map proposals
    uint
    {
        recipient: principal,
        amount: uint,
        votes: uint,
        executed: bool
    }
)
(define-map voted {proposal-id: uint, voter: principal} bool)
(define-data-var proposal-nonce uint u0)

(define-public (propose (recipient principal) (amount uint))
    (let ((id (var-get proposal-nonce)))
        (map-set proposals id {
            recipient: recipient,
            amount: amount,
            votes: u0,
            executed: false
        })
        (var-set proposal-nonce (+ id u1))
        (ok id)
    )
)

(define-public (vote (id uint))
    (let
        (
            (p (unwrap! (map-get? proposals id) (err u404)))
            (has-voted (default-to false (map-get? voted {proposal-id: id, voter: tx-sender})))
        )
        (asserts! (not has-voted) (err u403))
        (map-set voted {proposal-id: id, voter: tx-sender} true)
        (map-set proposals id (merge p {votes: (+ (get votes p) u1)}))
        (ok true)
    )
)

