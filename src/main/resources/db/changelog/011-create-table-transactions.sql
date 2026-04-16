--liquibase formatted sql

--changeset denny713:011-create-table-transactions
--comment: Create transactions table - activity log for all transactions (polymorphic reference)
CREATE TABLE transactions (
    id              UUID            PRIMARY KEY,
    transaction_no  VARCHAR(50)     NOT NULL UNIQUE,
    user_id         UUID            NOT NULL,
    wallet_id       UUID            NOT NULL,
    trans_type      VARCHAR(20)     NOT NULL
                                    CHECK (trans_type IN (
                                        'TOPUP', 'WITHDRAW', 'TRANSFER_IN',
                                        'TRANSFER_OUT', 'PAYMENT', 'REFUND'
                                    )),
    ref_type        VARCHAR(20)     NOT NULL
                                    CHECK (ref_type IN (
                                        'TOPUP', 'WITHDRAW', 'TRANSFER', 'PAYMENT'
                                    )),
    amount          DECIMAL(18, 2)  NOT NULL,
    balance_before  DECIMAL(18, 2)  NOT NULL,
    balance_after   DECIMAL(18, 2)  NOT NULL,
    direction       VARCHAR(5)      NOT NULL
                                    CHECK (direction IN ('IN', 'OUT')),
    status          VARCHAR(20)     NOT NULL DEFAULT 'SUCCESS'
                                    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REVERSED')),
    description     TEXT,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_transactions_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_transactions_no ON transactions(transaction_no);
CREATE INDEX idx_transactions_user ON transactions(user_id);
CREATE INDEX idx_transactions_wallet ON transactions(wallet_id);
CREATE INDEX idx_transactions_type ON transactions(trans_type);
CREATE INDEX idx_transactions_ref ON transactions(ref_type);
CREATE INDEX idx_transactions_direction ON transactions(direction);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_created ON transactions(created_at);
CREATE INDEX idx_transactions_user_created ON transactions(user_id, created_at DESC);

COMMENT ON TABLE transactions IS 'Activity log for all transactions in the system (polymorphic reference)';
COMMENT ON COLUMN transactions.ref_type IS 'Reference table type: TOPUP, WITHDRAW, TRANSFER, PAYMENT';
COMMENT ON COLUMN transactions.direction IS 'Transaction direction: IN (incoming) or OUT (outgoing)';
COMMENT ON COLUMN transactions.balance_before IS 'Wallet balance before the transaction';
COMMENT ON COLUMN transactions.balance_after IS 'Wallet balance after the transaction';

--rollback DROP TABLE IF EXISTS transactions CASCADE;
