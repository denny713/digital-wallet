--liquibase formatted sql

--changeset denny713:007-create-table-topups
--comment: Create topups table - top up transactions to wallet balance
CREATE TABLE topups (
    id              UUID            PRIMARY KEY,
    topup_no        VARCHAR(50)     NOT NULL UNIQUE,
    user_id         UUID            NOT NULL,
    wallet_id       UUID            NOT NULL,
    amount          DECIMAL(18, 2)  NOT NULL CHECK (amount > 0),
    admin_fee       DECIMAL(18, 2)  NOT NULL DEFAULT 0.00,
    total_amount    DECIMAL(18, 2)  NOT NULL CHECK (total_amount > 0),
    payment_method  VARCHAR(30)     NOT NULL
                                    CHECK (payment_method IN (
                                        'BANK_TRANSFER', 'VIRTUAL_ACCOUNT',
                                        'CREDIT_CARD', 'DEBIT_CARD',
                                        'CONVENIENCE_STORE', 'OTC'
                                    )),
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                                    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'EXPIRED', 'CANCELLED')),
    ref_no          VARCHAR(100),
    description     TEXT,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_topups_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_topups_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_topups_no ON topups(topup_no);
CREATE INDEX idx_topups_user ON topups(user_id);
CREATE INDEX idx_topups_wallet ON topups(wallet_id);
CREATE INDEX idx_topups_status ON topups(status);
CREATE INDEX idx_topups_created ON topups(created_at);

COMMENT ON TABLE topups IS 'Top up transactions to add balance into wallets';
COMMENT ON COLUMN topups.total_amount IS 'Total amount charged = amount + admin_fee';

--rollback DROP TABLE IF EXISTS topups CASCADE;
