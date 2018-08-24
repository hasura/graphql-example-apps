--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg14.04+1)
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hdb_catalog; Type: SCHEMA; Schema: -; Owner: qbcstsikhutxrh
--

CREATE SCHEMA hdb_catalog;


ALTER SCHEMA hdb_catalog OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_views; Type: SCHEMA; Schema: -; Owner: qbcstsikhutxrh
--

CREATE SCHEMA hdb_views;


ALTER SCHEMA hdb_views OWNER TO qbcstsikhutxrh;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = hdb_catalog, pg_catalog;

--
-- Name: first_agg(anyelement, anyelement); Type: FUNCTION; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE FUNCTION first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
       SELECT $1;
$_$;


ALTER FUNCTION hdb_catalog.first_agg(anyelement, anyelement) OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_table_oid_check(); Type: FUNCTION; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE FUNCTION hdb_table_oid_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF (EXISTS (SELECT 1 FROM information_schema.tables st WHERE st.table_schema = NEW.table_schema AND st.table_name = NEW.table_name)) THEN
      return NEW;
    ELSE
      RAISE foreign_key_violation using message = 'table_schema, table_name not in information_schema.tables';
      return NULL;
    END IF;
  END;
$$;


ALTER FUNCTION hdb_catalog.hdb_table_oid_check() OWNER TO qbcstsikhutxrh;

--
-- Name: inject_table_defaults(text, text, text, text); Type: FUNCTION; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE FUNCTION inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
    DECLARE
        r RECORD;
    BEGIN
      FOR r IN SELECT column_name, column_default FROM information_schema.columns WHERE table_schema = tab_schema AND table_name = tab_name AND column_default IS NOT NULL LOOP
          EXECUTE format('ALTER VIEW %I.%I ALTER COLUMN %I SET DEFAULT %s;', view_schema, view_name, r.column_name, r.column_default);
      END LOOP;
    END;
$$;


ALTER FUNCTION hdb_catalog.inject_table_defaults(view_schema text, view_name text, tab_schema text, tab_name text) OWNER TO qbcstsikhutxrh;

--
-- Name: last_agg(anyelement, anyelement); Type: FUNCTION; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE FUNCTION last_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
        SELECT $2;
$_$;


ALTER FUNCTION hdb_catalog.last_agg(anyelement, anyelement) OWNER TO qbcstsikhutxrh;

--
-- Name: first(anyelement); Type: AGGREGATE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE AGGREGATE first(anyelement) (
    SFUNC = first_agg,
    STYPE = anyelement
);


ALTER AGGREGATE hdb_catalog.first(anyelement) OWNER TO qbcstsikhutxrh;

--
-- Name: last(anyelement); Type: AGGREGATE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE AGGREGATE last(anyelement) (
    SFUNC = last_agg,
    STYPE = anyelement
);


ALTER AGGREGATE hdb_catalog.last(anyelement) OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_check_constraint; Type: VIEW; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE VIEW hdb_check_constraint AS
 SELECT (n.nspname)::text AS table_schema,
    (ct.relname)::text AS table_name,
    (r.conname)::text AS constraint_name,
    pg_get_constraintdef(r.oid, true) AS "check"
   FROM ((pg_constraint r
     JOIN pg_class ct ON ((r.conrelid = ct.oid)))
     JOIN pg_namespace n ON ((ct.relnamespace = n.oid)))
  WHERE (r.contype = 'c'::"char");


ALTER TABLE hdb_check_constraint OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_foreign_key_constraint; Type: VIEW; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE VIEW hdb_foreign_key_constraint AS
 SELECT (q.table_schema)::text AS table_schema,
    (q.table_name)::text AS table_name,
    (q.constraint_name)::text AS constraint_name,
    (first(q.constraint_oid))::integer AS constraint_oid,
    (first(q.ref_table_table_schema))::text AS ref_table_table_schema,
    (first(q.ref_table))::text AS ref_table,
    json_object_agg(ac.attname, afc.attname) AS column_mapping,
    (first(q.confupdtype))::text AS on_update,
    (first(q.confdeltype))::text AS on_delete
   FROM ((( SELECT ctn.nspname AS table_schema,
            ct.relname AS table_name,
            r.conrelid AS table_id,
            r.conname AS constraint_name,
            r.oid AS constraint_oid,
            cftn.nspname AS ref_table_table_schema,
            cft.relname AS ref_table,
            r.confrelid AS ref_table_id,
            r.confupdtype,
            r.confdeltype,
            unnest(r.conkey) AS column_id,
            unnest(r.confkey) AS ref_column_id
           FROM ((((pg_constraint r
             JOIN pg_class ct ON ((r.conrelid = ct.oid)))
             JOIN pg_namespace ctn ON ((ct.relnamespace = ctn.oid)))
             JOIN pg_class cft ON ((r.confrelid = cft.oid)))
             JOIN pg_namespace cftn ON ((cft.relnamespace = cftn.oid)))
          WHERE (r.contype = 'f'::"char")) q
     JOIN pg_attribute ac ON (((q.column_id = ac.attnum) AND (q.table_id = ac.attrelid))))
     JOIN pg_attribute afc ON (((q.ref_column_id = afc.attnum) AND (q.ref_table_id = afc.attrelid))))
  GROUP BY q.table_schema, q.table_name, q.constraint_name;


ALTER TABLE hdb_foreign_key_constraint OWNER TO qbcstsikhutxrh;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: hdb_permission; Type: TABLE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TABLE hdb_permission (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    role_name text NOT NULL,
    perm_type text NOT NULL,
    perm_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_permission_perm_type_check CHECK ((perm_type = ANY (ARRAY['insert'::text, 'select'::text, 'update'::text, 'delete'::text])))
);


ALTER TABLE hdb_permission OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_permission_agg; Type: VIEW; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE VIEW hdb_permission_agg AS
 SELECT hdb_permission.table_schema,
    hdb_permission.table_name,
    hdb_permission.role_name,
    json_object_agg(hdb_permission.perm_type, hdb_permission.perm_def) AS permissions
   FROM hdb_permission
  GROUP BY hdb_permission.table_schema, hdb_permission.table_name, hdb_permission.role_name;


ALTER TABLE hdb_permission_agg OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_primary_key; Type: VIEW; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE VIEW hdb_primary_key AS
 SELECT tc.table_schema,
    tc.table_name,
    tc.constraint_name,
    json_agg(ccu.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN information_schema.constraint_column_usage ccu ON (((tc.constraint_name)::text = (ccu.constraint_name)::text)))
  WHERE ((tc.constraint_type)::text = 'PRIMARY KEY'::text)
  GROUP BY tc.table_schema, tc.table_name, tc.constraint_name;


ALTER TABLE hdb_primary_key OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_query_template; Type: TABLE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TABLE hdb_query_template (
    template_name text NOT NULL,
    template_defn jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_query_template OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_relationship; Type: TABLE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TABLE hdb_relationship (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    rel_name text NOT NULL,
    rel_type text,
    rel_def jsonb NOT NULL,
    comment text,
    is_system_defined boolean DEFAULT false,
    CONSTRAINT hdb_relationship_rel_type_check CHECK ((rel_type = ANY (ARRAY['object'::text, 'array'::text])))
);


ALTER TABLE hdb_relationship OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_table; Type: TABLE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TABLE hdb_table (
    table_schema text NOT NULL,
    table_name text NOT NULL,
    is_system_defined boolean DEFAULT false
);


ALTER TABLE hdb_table OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_unique_constraint; Type: VIEW; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE VIEW hdb_unique_constraint AS
 SELECT tc.table_name,
    tc.constraint_schema AS table_schema,
    tc.constraint_name,
    json_agg(kcu.column_name) AS columns
   FROM (information_schema.table_constraints tc
     JOIN information_schema.key_column_usage kcu USING (constraint_schema, constraint_name))
  WHERE ((tc.constraint_type)::text = 'UNIQUE'::text)
  GROUP BY tc.table_name, tc.constraint_schema, tc.constraint_name;


ALTER TABLE hdb_unique_constraint OWNER TO qbcstsikhutxrh;

--
-- Name: hdb_version; Type: TABLE; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TABLE hdb_version (
    version text NOT NULL,
    upgraded_on timestamp with time zone NOT NULL
);


ALTER TABLE hdb_version OWNER TO qbcstsikhutxrh;

SET search_path = public, pg_catalog;

--
-- Name: message; Type: TABLE; Schema: public; Owner: qbcstsikhutxrh
--

CREATE TABLE message (
    id integer NOT NULL,
    text text NOT NULL,
    username text NOT NULL,
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE message OWNER TO qbcstsikhutxrh;

--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: qbcstsikhutxrh
--

CREATE SEQUENCE message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE message_id_seq OWNER TO qbcstsikhutxrh;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qbcstsikhutxrh
--

ALTER SEQUENCE message_id_seq OWNED BY message.id;


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY message ALTER COLUMN id SET DEFAULT nextval('message_id_seq'::regclass);


SET search_path = hdb_catalog, pg_catalog;

--
-- Data for Name: hdb_permission; Type: TABLE DATA; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--



--
-- Data for Name: hdb_query_template; Type: TABLE DATA; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--



--
-- Data for Name: hdb_relationship; Type: TABLE DATA; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'detail', 'object', '{"manual_configuration": {"remote_table": {"name": "tables", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'primary_key', 'object', '{"manual_configuration": {"remote_table": {"name": "hdb_primary_key", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'columns', 'array', '{"manual_configuration": {"remote_table": {"name": "columns", "schema": "information_schema"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'foreign_key_constraints', 'array', '{"manual_configuration": {"remote_table": {"name": "hdb_foreign_key_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'relationships', 'array', '{"manual_configuration": {"remote_table": {"name": "hdb_relationship", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'permissions', 'array', '{"manual_configuration": {"remote_table": {"name": "hdb_permission_agg", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'check_constraints', 'array', '{"manual_configuration": {"remote_table": {"name": "hdb_check_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);
INSERT INTO hdb_relationship (table_schema, table_name, rel_name, rel_type, rel_def, comment, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', 'unique_constraints', 'array', '{"manual_configuration": {"remote_table": {"name": "hdb_unique_constraint", "schema": "hdb_catalog"}, "column_mapping": {"table_name": "table_name", "table_schema": "table_schema"}}}', NULL, true);


--
-- Data for Name: hdb_table; Type: TABLE DATA; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_table', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('information_schema', 'tables', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('information_schema', 'schemata', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('information_schema', 'views', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_primary_key', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('information_schema', 'columns', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_foreign_key_constraint', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_relationship', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_permission_agg', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_check_constraint', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_unique_constraint', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('hdb_catalog', 'hdb_query_template', true);
INSERT INTO hdb_table (table_schema, table_name, is_system_defined) VALUES ('public', 'message', false);


--
-- Data for Name: hdb_version; Type: TABLE DATA; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

INSERT INTO hdb_version (version, upgraded_on) VALUES ('1', '2018-08-16 10:01:15.732756+00');


SET search_path = public, pg_catalog;

--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: qbcstsikhutxrh
--

INSERT INTO message (id, text, username, "timestamp") VALUES (18, 'nice', 'one', '2018-08-24 10:20:56.6289+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (19, 'nice', 'one', '2018-08-24 10:21:01.369992+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (20, 'what?', 'asdfa', '2018-08-24 10:21:14.415065+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (21, 'hey', 'pravs', '2018-08-24 10:24:22.04994+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (22, 'wazzie?', 'rishi', '2018-08-24 10:24:26.388247+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (23, 'crossfit sucks', 'rishi', '2018-08-24 10:24:36.263745+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (24, 'ksdkd', 'rishi', '2018-08-24 10:24:43.667021+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (25, 'fd', 'rishi', '2018-08-24 10:24:44.531916+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (26, 'kjkds', 'rishi', '2018-08-24 10:24:45.419132+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (27, 'jdkfj', 'rishi', '2018-08-24 10:24:46.167107+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (28, 'lasddfks', 'rishi', '2018-08-24 10:24:47.815156+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (29, 'sdf', 'pravs', '2018-08-24 10:24:48.327674+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (30, 'klsdjklf', 'rishi', '2018-08-24 10:24:49.127576+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (31, 'klasdjklfa', 'rishi', '2018-08-24 10:24:50.323953+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (32, 'sfsdf', 'pravs', '2018-08-24 10:24:51.099234+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (33, 'lasdf', 'rishi', '2018-08-24 10:24:52.474941+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (34, 'asdklfakls', 'rishi', '2018-08-24 10:24:53.833474+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (35, 'dffd', 'pravs', '2018-08-24 10:25:00.43577+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (36, 'askldjklfa', 'rishi', '2018-08-24 10:25:00.460182+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (37, 'asdklfjklasdjkla', 'rishi', '2018-08-24 10:25:01.797233+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (38, 'dfsf', 'pravs', '2018-08-24 10:25:08.935166+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (39, 'dsdfsfsfsf', 'pravs', '2018-08-24 10:25:18.414973+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (40, 'wewee', 'pravs', '2018-08-24 10:25:20.176738+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (41, 'asdfasdf', 'rishi', '2018-08-24 10:25:30.065709+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (42, 'ndfn', 'pravs', '2018-08-24 10:25:43.390125+00');
INSERT INTO message (id, text, username, "timestamp") VALUES (43, 'ndlkdf', 'abcd', '2018-08-24 10:26:35.74565+00');


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qbcstsikhutxrh
--

SELECT pg_catalog.setval('message_id_seq', 43, true);


SET search_path = hdb_catalog, pg_catalog;

--
-- Name: hdb_permission hdb_permission_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_permission
    ADD CONSTRAINT hdb_permission_pkey PRIMARY KEY (table_schema, table_name, role_name, perm_type);


--
-- Name: hdb_query_template hdb_query_template_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_query_template
    ADD CONSTRAINT hdb_query_template_pkey PRIMARY KEY (template_name);


--
-- Name: hdb_relationship hdb_relationship_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_relationship
    ADD CONSTRAINT hdb_relationship_pkey PRIMARY KEY (table_schema, table_name, rel_name);


--
-- Name: hdb_table hdb_table_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_table
    ADD CONSTRAINT hdb_table_pkey PRIMARY KEY (table_schema, table_name);


SET search_path = public, pg_catalog;

--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


SET search_path = hdb_catalog, pg_catalog;

--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: hdb_table hdb_table_oid_check; Type: TRIGGER; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

CREATE TRIGGER hdb_table_oid_check BEFORE INSERT OR UPDATE ON hdb_catalog.hdb_table FOR EACH ROW EXECUTE PROCEDURE hdb_table_oid_check();


--
-- Name: hdb_permission hdb_permission_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_permission
    ADD CONSTRAINT hdb_permission_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_table(table_schema, table_name);


--
-- Name: hdb_relationship hdb_relationship_table_schema_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: qbcstsikhutxrh
--

ALTER TABLE ONLY hdb_relationship
    ADD CONSTRAINT hdb_relationship_table_schema_fkey FOREIGN KEY (table_schema, table_name) REFERENCES hdb_table(table_schema, table_name);


--
-- Name: public; Type: ACL; Schema: -; Owner: qbcstsikhutxrh
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO qbcstsikhutxrh;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO qbcstsikhutxrh;


--
-- PostgreSQL database dump complete
--

