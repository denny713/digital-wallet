--liquibase formatted sql

--changeset denny713:003-create-table-users
--comment: Create users table - digital wallet user information
CREATE TABLE users (
    id              UUID            PRIMARY KEY,
    name            VARCHAR(150)    NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    phone           VARCHAR(20)     NOT NULL UNIQUE,
    password        VARCHAR(100)    NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'ACTIVE'
                                    CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'BLOCKED')),
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_deleted ON users(deleted_at);

COMMENT ON TABLE users IS 'Digital wallet user information';
COMMENT ON COLUMN users.password IS 'Hashed password for transaction authorization';

--rollback DROP TABLE IF EXISTS users CASCADE;
