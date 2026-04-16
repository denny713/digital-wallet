--liquibase formatted sql

--changeset denny713:006-create-table-merchants
--comment: Create merchants table - master data for payment service providers
CREATE TABLE merchants (
    id              UUID            PRIMARY KEY,
    user_id         UUID,
    code            VARCHAR(30)     NOT NULL UNIQUE,
    name            VARCHAR(150)    NOT NULL,
    category        VARCHAR(50),
    description     TEXT,
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
                                    CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP,

    CONSTRAINT fk_merchants_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE INDEX idx_merchants_code ON merchants(code);
CREATE INDEX idx_merchants_user ON merchants(user_id);
CREATE INDEX idx_merchants_status ON merchants(status);
CREATE INDEX idx_merchants_deleted ON merchants(deleted_at);

COMMENT ON TABLE merchants IS 'Master data for merchants accepting payments';

--rollback DROP TABLE IF EXISTS merchants CASCADE;
