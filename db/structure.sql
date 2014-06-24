--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: contact_preference; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE contact_preference AS ENUM (
    'email',
    'post',
    'fax'
);


--
-- Name: gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE gender AS ENUM (
    'male',
    'female'
);


--
-- Name: person_title; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE person_title AS ENUM (
    'mr',
    'mrs',
    'miss',
    'ms'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    building character varying(255),
    street character varying(255),
    locality character varying(255),
    county character varying(255),
    post_code character varying(255),
    addressable_id integer,
    addressable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: claimants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE claimants (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    date_of_birth date,
    telephone_number character varying(255),
    mobile_number character varying(255),
    fax_number character varying(255),
    email_address character varying(255),
    special_needs text,
    title person_title,
    gender gender,
    contact_preference contact_preference,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    claim_id integer
);


--
-- Name: claimants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claimants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claimants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE claimants_id_seq OWNED BY claimants.id;


--
-- Name: claims; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE claims (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    stack character varying(255)[] DEFAULT '{}'::character varying[],
    password_digest character varying(255)
);


--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE claims_id_seq OWNED BY claims.id;


--
-- Name: representatives; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE representatives (
    id integer NOT NULL,
    type character varying(255),
    organisation_name character varying(255),
    name character varying(255),
    telephone_number character varying(255),
    mobile_number character varying(255),
    email_address character varying(255),
    dx_number character varying(255),
    claim_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: representatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE representatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: representatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE representatives_id_seq OWNED BY representatives.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY claimants ALTER COLUMN id SET DEFAULT nextval('claimants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY claims ALTER COLUMN id SET DEFAULT nextval('claims_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY representatives ALTER COLUMN id SET DEFAULT nextval('representatives_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: claimants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY claimants
    ADD CONSTRAINT claimants_pkey PRIMARY KEY (id);


--
-- Name: claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY claims
    ADD CONSTRAINT claims_pkey PRIMARY KEY (id);


--
-- Name: representatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY representatives
    ADD CONSTRAINT representatives_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140603135125');

INSERT INTO schema_migrations (version) VALUES ('20140603155053');

INSERT INTO schema_migrations (version) VALUES ('20140604105856');

INSERT INTO schema_migrations (version) VALUES ('20140605092649');

INSERT INTO schema_migrations (version) VALUES ('20140616151523');

INSERT INTO schema_migrations (version) VALUES ('20140617162645');

INSERT INTO schema_migrations (version) VALUES ('20140624134653');

