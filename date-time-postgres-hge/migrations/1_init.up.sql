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
-- Name: datetime_graphql; Type: TABLE; Schema: public; Owner: fwaaahmxcqpkoo
--

CREATE TABLE public.datetime_graphql (
    id integer NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    edited timestamp with time zone
);


ALTER TABLE public.datetime_graphql OWNER TO fwaaahmxcqpkoo;

--
-- Name: datetime_graphql_id_seq; Type: SEQUENCE; Schema: public; Owner: fwaaahmxcqpkoo
--

CREATE SEQUENCE public.datetime_graphql_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.datetime_graphql_id_seq OWNER TO fwaaahmxcqpkoo;

--
-- Name: datetime_graphql_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fwaaahmxcqpkoo
--

ALTER SEQUENCE public.datetime_graphql_id_seq OWNED BY public.datetime_graphql.id;


--
-- Name: datetime_graphql id; Type: DEFAULT; Schema: public; Owner: fwaaahmxcqpkoo
--

ALTER TABLE ONLY public.datetime_graphql ALTER COLUMN id SET DEFAULT nextval('public.datetime_graphql_id_seq'::regclass);


--
-- Data for Name: datetime_graphql; Type: TABLE DATA; Schema: public; Owner: fwaaahmxcqpkoo
--

INSERT INTO public.datetime_graphql (id, created, edited) VALUES (2, '2018-08-12 08:56:37.331336+00', NULL);
INSERT INTO public.datetime_graphql (id, created, edited) VALUES (3, '2018-08-17 12:02:01.302564+00', '2018-08-12 08:56:37.331336+00');


--
-- Name: datetime_graphql_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fwaaahmxcqpkoo
--

SELECT pg_catalog.setval('public.datetime_graphql_id_seq', 3, true);


--
-- Name: datetime_graphql datetime_graphql_pkey; Type: CONSTRAINT; Schema: public; Owner: fwaaahmxcqpkoo
--

ALTER TABLE ONLY public.datetime_graphql
    ADD CONSTRAINT datetime_graphql_pkey PRIMARY KEY (id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: fwaaahmxcqpkoo
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO fwaaahmxcqpkoo;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

