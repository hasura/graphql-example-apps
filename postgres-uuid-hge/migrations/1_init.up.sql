--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg14.04+1)
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: id_graphql; Type: TABLE; Schema: public; Owner: hnjtxoqqpczmqj
--

CREATE TABLE public.id_graphql (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.id_graphql OWNER TO hnjtxoqqpczmqj;

--
-- Name: id_graphql_id_seq; Type: SEQUENCE; Schema: public; Owner: hnjtxoqqpczmqj
--

CREATE SEQUENCE public.id_graphql_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.id_graphql_id_seq OWNER TO hnjtxoqqpczmqj;

--
-- Name: id_graphql_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hnjtxoqqpczmqj
--

ALTER SEQUENCE public.id_graphql_id_seq OWNED BY public.id_graphql.id;


--
-- Name: uuid_graphql; Type: TABLE; Schema: public; Owner: hnjtxoqqpczmqj
--

CREATE TABLE public.uuid_graphql (
    uuid uuid NOT NULL,
    name text
);


ALTER TABLE public.uuid_graphql OWNER TO hnjtxoqqpczmqj;

--
-- Name: id_graphql id; Type: DEFAULT; Schema: public; Owner: hnjtxoqqpczmqj
--

ALTER TABLE ONLY public.id_graphql ALTER COLUMN id SET DEFAULT nextval('public.id_graphql_id_seq'::regclass);


--
-- Data for Name: id_graphql; Type: TABLE DATA; Schema: public; Owner: hnjtxoqqpczmqj
--



--
-- Data for Name: uuid_graphql; Type: TABLE DATA; Schema: public; Owner: hnjtxoqqpczmqj
--

INSERT INTO public.uuid_graphql (uuid, name) VALUES ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'first');


--
-- Name: id_graphql_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hnjtxoqqpczmqj
--

SELECT pg_catalog.setval('public.id_graphql_id_seq', 1, false);


--
-- Name: id_graphql id_graphql_pkey; Type: CONSTRAINT; Schema: public; Owner: hnjtxoqqpczmqj
--

ALTER TABLE ONLY public.id_graphql
    ADD CONSTRAINT id_graphql_pkey PRIMARY KEY (id);


--
-- Name: uuid_graphql uuid_graphql_pkey; Type: CONSTRAINT; Schema: public; Owner: hnjtxoqqpczmqj
--

ALTER TABLE ONLY public.uuid_graphql
    ADD CONSTRAINT uuid_graphql_pkey PRIMARY KEY (uuid);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: hnjtxoqqpczmqj
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO hnjtxoqqpczmqj;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

