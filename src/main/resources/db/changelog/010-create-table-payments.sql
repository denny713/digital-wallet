--liquibase formatted sql

--changeset denny713:010-create-table-payments
--comment: Create payments table - payment transactions to merchants
CREATE TABLE payments (
    id              UUID            PRIMARY KEY,
    payment_no      VARCHAR(50)     NOT NULL UNIQUE,
    user_id         UUID            NOT NULL,
    wallet_id       UUID            NOT NULL,
    merchant_id     UUID            NOT NULL,
    amount          DECIMAL(18, 2)  NOT NULL CHECK (amount > 0),
    admin_fee       DECIMAL(18, 2)  NOT NULL DEFAULT 0.00,
    total_amount    DECIMAL(18, 2)  NOT NULL CHECK (total_amount > 0),
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                                    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED', 'EXPIRED')),
    payment_ref     VARCHAR(100),
    merchant_ref    VARCHAR(100),
    description     TEXT,
    expired_at      TIMESTAMP,
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_payments_wallet
        FOREIGN KEY (wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_payments_merchant
        FOREIGN KEY (merchant_id) REFERENCES merchants(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE INDEX idx_payments_no ON payments(payment_no);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_wallet ON payments(wallet_id);
CREATE INDEX idx_payments_merchant ON payments(merchant_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_created ON payments(created_at);

COMMENT ON TABLE payments IS 'Payment transactions to merchants';
COMMENT ON COLUMN payments.merchant_ref IS 'Reference number from the merchant side';

--rollback DROP TABLE IF EXISTS payments CASCADE;
