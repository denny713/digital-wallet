--liquibase formatted sql

--changeset denny713:002-create-table-banks
--comment: Create banks table - master data of available banks
CREATE TABLE banks (
    id              UUID            PRIMARY KEY,
    code            VARCHAR(20)     NOT NULL UNIQUE,
    name            VARCHAR(100)    NOT NULL,
    swift           VARCHAR(20),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP
);

CREATE INDEX idx_banks_code ON banks(code);
CREATE INDEX idx_banks_deleted ON banks(deleted_at);

COMMENT ON TABLE banks IS 'Master data of banks available in the digital wallet system';
COMMENT ON COLUMN banks.code IS 'Unique bank code (e.g., BCA, BNI, MANDIRI)';
COMMENT ON COLUMN banks.swift IS 'SWIFT/BIC code for international transactions';

--rollback DROP TABLE IF EXISTS banks CASCADE;
