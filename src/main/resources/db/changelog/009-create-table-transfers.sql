--liquibase formatted sql

--changeset denny713:009-create-table-transfers
--comment: Create transfers table - fund transfer transactions between users (wallet to wallet)
CREATE TABLE transfers (
    id              UUID            PRIMARY KEY,
    transfer_no     VARCHAR(50)     NOT NULL UNIQUE,
    sender_id       UUID            NOT NULL,
    sender_wallet_id UUID           NOT NULL,
    receiver_id     UUID            NOT NULL,
    receiver_wallet_id UUID         NOT NULL,
    amount          DECIMAL(18, 2)  NOT NULL CHECK (amount > 0),
    admin_fee       DECIMAL(18, 2)  NOT NULL DEFAULT 0.00,
    total_deducted  DECIMAL(18, 2)  NOT NULL CHECK (total_deducted > 0),
    status          VARCHAR(20)     NOT NULL DEFAULT 'PENDING'
                                    CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REVERSED')),
    description     TEXT,
    ref_no          VARCHAR(100),
    completed_at    TIMESTAMP,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transfers_sender
        FOREIGN KEY (sender_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_transfers_sender_wallet
        FOREIGN KEY (sender_wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_transfers_receiver
        FOREIGN KEY (receiver_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_transfers_receiver_wallet
        FOREIGN KEY (receiver_wallet_id) REFERENCES wallets(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT chk_transfers_diff_user
        CHECK (sender_id <> receiver_id)
);

CREATE INDEX idx_transfers_no ON transfers(transfer_no);
CREATE INDEX idx_transfers_sender ON transfers(sender_id);
CREATE INDEX idx_transfers_receiver ON transfers(receiver_id);
CREATE INDEX idx_transfers_sender_wallet ON transfers(sender_wallet_id);
CREATE INDEX idx_transfers_receiver_wallet ON transfers(receiver_wallet_id);
CREATE INDEX idx_transfers_status ON transfers(status);
CREATE INDEX idx_transfers_created ON transfers(created_at);

COMMENT ON TABLE transfers IS 'Fund transfer transactions between users (wallet to wallet)';
COMMENT ON COLUMN transfers.total_deducted IS 'Total deducted from sender = amount + admin_fee';

--rollback DROP TABLE IF EXISTS transfers CASCADE;
