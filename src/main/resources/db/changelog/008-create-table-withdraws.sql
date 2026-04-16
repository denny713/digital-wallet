--liquibase formatted sql

--changeset denny713:008-create-table-withdraws
--comment: Create withdraws table - withdrawal transactions from wallet to bank account
CREATE TABLE withdraws (
    id              UUID            PRIMARY KEY,
    withdraw_no     VARCHAR(50)     NOT NULL UNIQUE,
    user_id         UUID            NOT NULL,
    wallet_id       UUID            NOT NULL,
    account_id      UUID            NOT NULL,
    amount          DECIMAL(18, 2)  NOT NULL CHECK (amount > 0),
    admin_fee       DECIMAL(18, 2)  NOT NULL DEFAULT 0.00,
    total_deducted  DECIMAL(18, 2)  NOT NULL CHECK (total_deducted > 0),
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                                    CHECK (status IN ('PENDING', 'PROCESSING', 'SUCCESS', 'FAILED', 'REJECTED')),
    ref_no          VARCHAR(100),
    reject_reason   TEXT,
    description     TEXT,
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_withdraws_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_withdraws_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_withdraws_account
        FOREIGN KEY (account_id) REFERENCES accounts(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_withdraws_no ON withdraws(withdraw_no);
CREATE INDEX idx_withdraws_user ON withdraws(user_id);
CREATE INDEX idx_withdraws_wallet ON withdraws(wallet_id);
CREATE INDEX idx_withdraws_account ON withdraws(account_id);
CREATE INDEX idx_withdraws_status ON withdraws(status);
CREATE INDEX idx_withdraws_created ON withdraws(created_at);

COMMENT ON TABLE withdraws IS 'Withdrawal transactions from wallet to bank account';
COMMENT ON COLUMN withdraws.total_deducted IS 'Total deducted from wallet = amount + admin_fee';

--rollback DROP TABLE IF EXISTS withdraws CASCADE;
