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
-- Name: get_distance_km(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION get_distance_km(alat double precision, alon double precision, lat double precision, lon double precision) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
      DECLARE
          radius_earth FLOAT;
          radian_lat FLOAT;
          radian_lon FLOAT;
          distance_v FLOAT;
          distance_h FLOAT;
          distance FLOAT;
      BEGIN
          -- Insert earth radius
          SELECT INTO radius_earth 6378.137;
       
          -- Calculate difference between lat and alat
          SELECT INTO radian_lat radians(lat - alat);
       
          -- Calculate difference between lon and alon
          SELECT INTO radian_lon radians(lon - alon);
       
          -- Calculate vertical distance
          SELECT INTO distance_v (radius_earth * radian_lat);
       
          -- Calculate horizontal distance
          SELECT INTO distance_h (cos(radians(alat)) * radius_earth * radian_lon);
       
          -- Calculate distance(km)
          SELECT INTO distance sqrt(pow(distance_h,2) + pow(distance_v,2));
       
          -- Returns distance
          RETURN DISTANCE;
      END;
      $$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: establishments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE establishments (
    id integer NOT NULL,
    address character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latlng point,
    latest_name character varying(255),
    latest_type character varying(255)
);


--
-- Name: establishments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE establishments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: establishments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE establishments_id_seq OWNED BY establishments.id;


--
-- Name: geocodes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE geocodes (
    id integer NOT NULL,
    address character varying(255),
    postal_code character varying(255),
    geocoding_results_json text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latlng point
);


--
-- Name: geocodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE geocodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geocodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE geocodes_id_seq OWNED BY geocodes.id;


--
-- Name: infractions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE infractions (
    id integer NOT NULL,
    inspection_id integer,
    details character varying(255),
    severity character varying(255),
    action character varying(255),
    court_outcome character varying(255),
    amount_fined double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: infractions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE infractions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE infractions_id_seq OWNED BY infractions.id;


--
-- Name: inspections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inspections (
    id integer NOT NULL,
    establishment_id integer,
    status character varying(255),
    minimum_inspections_per_year integer,
    date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    establishment_name character varying(255),
    establishment_type character varying(255)
);


--
-- Name: inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inspections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inspections_id_seq OWNED BY inspections.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY establishments ALTER COLUMN id SET DEFAULT nextval('establishments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY geocodes ALTER COLUMN id SET DEFAULT nextval('geocodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY infractions ALTER COLUMN id SET DEFAULT nextval('infractions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inspections ALTER COLUMN id SET DEFAULT nextval('inspections_id_seq'::regclass);


--
-- Name: establishments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY establishments
    ADD CONSTRAINT establishments_pkey PRIMARY KEY (id);


--
-- Name: geocodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY geocodes
    ADD CONSTRAINT geocodes_pkey PRIMARY KEY (id);


--
-- Name: infractions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY infractions
    ADD CONSTRAINT infractions_pkey PRIMARY KEY (id);


--
-- Name: inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inspections
    ADD CONSTRAINT inspections_pkey PRIMARY KEY (id);


--
-- Name: index_establishments_on_latlng; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_establishments_on_latlng ON establishments USING gist (latlng);


--
-- Name: index_inspections_on_establishment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_inspections_on_establishment_id ON inspections USING btree (establishment_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20111130195323');

INSERT INTO schema_migrations (version) VALUES ('20111202170638');

INSERT INTO schema_migrations (version) VALUES ('20111205223704');

INSERT INTO schema_migrations (version) VALUES ('20120417224952');

INSERT INTO schema_migrations (version) VALUES ('20121111072059');

INSERT INTO schema_migrations (version) VALUES ('20121111075800');

INSERT INTO schema_migrations (version) VALUES ('20121112065027');

INSERT INTO schema_migrations (version) VALUES ('20121114030257');

INSERT INTO schema_migrations (version) VALUES ('20121117040447');

INSERT INTO schema_migrations (version) VALUES ('20121117062637');

INSERT INTO schema_migrations (version) VALUES ('20121117170332');

INSERT INTO schema_migrations (version) VALUES ('20121117211553');

INSERT INTO schema_migrations (version) VALUES ('20121117212248');

INSERT INTO schema_migrations (version) VALUES ('20121117213519');

INSERT INTO schema_migrations (version) VALUES ('20121117222003');

INSERT INTO schema_migrations (version) VALUES ('20121207041154');