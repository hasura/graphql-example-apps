--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg14.04+1)
-- Dumped by pg_dump version 10.5 (Ubuntu 10.5-0ubuntu0.18.04)

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

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

--
-- Name: product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product (
    uuid uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    price numeric NOT NULL,
    spec jsonb NOT NULL,
    category text NOT NULL
);


--
-- Name: TABLE product; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.product IS 'Table containing all product information';


--
-- Name: laptop_listing; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.laptop_listing AS
 SELECT product.name,
    product.price,
    (product.spec ->> 'processor'::text) AS processor,
    (product.spec ->> 'ram'::text) AS ram,
    (product.spec ->> 'disk'::text) AS disk,
    (product.spec ->> 'display'::text) AS display
   FROM public.product
  WHERE (product.category = 'Laptop'::text);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (uuid);


--
-- PostgreSQL database dump complete
--

