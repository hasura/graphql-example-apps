--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg14.04+1)
-- Dumped by pg_dump version 10.4 (Ubuntu 10.4-0ubuntu0.18.04)

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
-- Name: test; Type: TABLE; Schema: public; Owner: hzcgsljxzphhyb
--

CREATE TABLE public.test (
    id integer NOT NULL
);


ALTER TABLE public.test OWNER TO hzcgsljxzphhyb;

--
-- Name: test_id_seq; Type: SEQUENCE; Schema: public; Owner: hzcgsljxzphhyb
--

CREATE SEQUENCE public.test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_id_seq OWNER TO hzcgsljxzphhyb;

--
-- Name: test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: hzcgsljxzphhyb
--

ALTER SEQUENCE public.test_id_seq OWNED BY public.test.id;


--
-- Name: test id; Type: DEFAULT; Schema: public; Owner: hzcgsljxzphhyb
--

ALTER TABLE ONLY public.test ALTER COLUMN id SET DEFAULT nextval('public.test_id_seq'::regclass);


--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: hzcgsljxzphhyb
--



--
-- Name: test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: hzcgsljxzphhyb
--

SELECT pg_catalog.setval('public.test_id_seq', 1, false);


--
-- Name: test test_pkey; Type: CONSTRAINT; Schema: public; Owner: hzcgsljxzphhyb
--

ALTER TABLE ONLY public.test
    ADD CONSTRAINT test_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

