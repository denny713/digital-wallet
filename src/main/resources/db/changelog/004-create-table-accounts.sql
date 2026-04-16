--liquibase formatted sql

--changeset denny713:004-create-table-accounts
--comment: Create accounts table - bank accounts registered by users
CREATE TABLE accounts (
    id              UUID            PRIMARY KEY,
    user_id         UUID            NOT NULL,
    bank_id         UUID            NOT NULL,
    account_no      VARCHAR(30)     NOT NULL,
    name            VARCHAR(150)    NOT NULL,
    is_primary      BOOLEAN         NOT NULL DEFAULT FALSE,
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
                                    CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP,

    CONSTRAINT fk_accounts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_accounts_bank
        FOREIGN KEY (bank_id) REFERENCES banks(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT uq_accounts_bank_no
        UNIQUE (bank_id, account_no)
);

CREATE INDEX idx_accounts_user ON accounts(user_id);
CREATE INDEX idx_accounts_bank ON accounts(bank_id);
CREATE INDEX idx_accounts_deleted ON accounts(deleted_at);

COMMENT ON TABLE accounts IS 'Bank accounts registered by users';
COMMENT ON COLUMN accounts.is_primary IS 'Indicates whether this is the user primary bank account';

--rollback DROP TABLE IF EXISTS accounts CASCADE;
