--liquibase formatted sql

--changeset denny713:005-create-table-wallets
--comment: Create wallets table - user digital wallet balance information
CREATE TABLE wallets (
    id              UUID            PRIMARY KEY,
    user_id         UUID            NOT NULL,
    wallet_no       VARCHAR(30)     NOT NULL UNIQUE,
    balance         DECIMAL(18, 2)  NOT NULL DEFAULT 0.00
                                    CHECK (balance >= 0),
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
                                    CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED')),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_wallets_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_wallets_user ON wallets(user_id);
CREATE INDEX idx_wallets_no ON wallets(wallet_no);
CREATE INDEX idx_wallets_status ON wallets(status);

COMMENT ON TABLE wallets IS 'User digital wallets holding balance information';
COMMENT ON COLUMN wallets.balance IS 'Current balance (must be non-negative)';
COMMENT ON COLUMN wallets.wallet_no IS 'Unique wallet identifier number';

--rollback DROP TABLE IF EXISTS wallets CASCADE;
