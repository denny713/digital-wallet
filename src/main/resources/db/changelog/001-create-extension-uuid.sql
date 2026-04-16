--liquibase formatted sql

--changeset denny713:001-create-extension-uuid
--comment: Enable UUID generation extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--rollback DROP EXTENSION IF EXISTS "uuid-ossp";
