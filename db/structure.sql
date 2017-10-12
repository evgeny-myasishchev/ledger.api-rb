SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_categories (
    id bigint NOT NULL,
    ledger_id character varying NOT NULL,
    display_order integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: account_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_categories_id_seq OWNED BY account_categories.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id character varying NOT NULL,
    ledger_id character varying NOT NULL,
    name character varying NOT NULL,
    display_order integer NOT NULL,
    created_user_id character varying NOT NULL,
    account_category_id integer,
    currency_code character varying NOT NULL,
    unit character varying,
    balance integer DEFAULT 0 NOT NULL,
    pending_balance integer DEFAULT 0 NOT NULL,
    is_closed boolean DEFAULT false NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ledger_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ledger_users (
    ledger_id character varying NOT NULL,
    user_id character varying NOT NULL,
    is_owner boolean DEFAULT false NOT NULL
);


--
-- Name: ledgers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ledgers (
    id character varying NOT NULL,
    name character varying NOT NULL,
    created_user_id character varying NOT NULL,
    currency_code character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tags (
    id bigint NOT NULL,
    ledger_id character varying NOT NULL,
    name character varying NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE transactions (
    id character varying NOT NULL,
    account_id character varying,
    reported_user_id character varying NOT NULL,
    type_id character varying NOT NULL,
    amount integer NOT NULL,
    comment text,
    date timestamp without time zone NOT NULL,
    is_refund boolean DEFAULT false NOT NULL,
    is_transfer boolean DEFAULT false NOT NULL,
    is_pending boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: account_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_categories ALTER COLUMN id SET DEFAULT nextval('account_categories_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: account_categories account_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_categories
    ADD CONSTRAINT account_categories_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: ledgers ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ledgers
    ADD CONSTRAINT ledgers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: index_account_categories_on_id_and_ledger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_account_categories_on_id_and_ledger_id ON account_categories USING btree (id, ledger_id);


--
-- Name: index_ledger_users_on_ledger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ledger_users_on_ledger_id ON ledger_users USING btree (ledger_id);


--
-- Name: index_ledger_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ledger_users_on_user_id ON ledger_users USING btree (user_id);


--
-- Name: index_tags_on_ledger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_ledger_id ON tags USING btree (ledger_id);


--
-- Name: index_transactions_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_account_id ON transactions USING btree (account_id);


--
-- Name: accounts fk_acc_on_acc_cat_id_lid_refs_acc_cat_on_id_lid; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_acc_on_acc_cat_id_lid_refs_acc_cat_on_id_lid FOREIGN KEY (account_category_id, ledger_id) REFERENCES account_categories(id, ledger_id);


--
-- Name: account_categories fk_account_categories_on_ledger_id_refs_ledgers_on_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_categories
    ADD CONSTRAINT fk_account_categories_on_ledger_id_refs_ledgers_on_id FOREIGN KEY (ledger_id) REFERENCES ledgers(id);


--
-- Name: accounts fk_accounts_on_ledger_id_refs_ledgers_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_accounts_on_ledger_id_refs_ledgers_id FOREIGN KEY (ledger_id) REFERENCES ledgers(id);


--
-- Name: ledger_users fk_ledger_users_on_ledger_id_refs_ledgers_on_ledger_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ledger_users
    ADD CONSTRAINT fk_ledger_users_on_ledger_id_refs_ledgers_on_ledger_id FOREIGN KEY (ledger_id) REFERENCES ledgers(id);


--
-- Name: transactions fk_rails_01f020e267; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT fk_rails_01f020e267 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: tags fk_rails_d8be626a4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT fk_rails_d8be626a4c FOREIGN KEY (ledger_id) REFERENCES ledgers(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170927053002'),
('20170927054206'),
('20170927060507'),
('20170927060627'),
('20171009064434'),
('20171010054348');


