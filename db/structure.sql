SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: get_distance_km(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_distance_km(alat double precision, alon double precision, lat double precision, lon double precision) RETURNS double precision
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

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: establishments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.establishments (
    id integer NOT NULL,
    address character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latlng point,
    latest_name character varying(255),
    latest_type character varying(255),
    deleted_at timestamp without time zone,
    earth_coord public.earth,
    min_inspection_date date,
    max_inspection_date date,
    last_closed_inspection_date date,
    last_conditional_inspection_date date
);


--
-- Name: establishments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.establishments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: establishments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.establishments_id_seq OWNED BY public.establishments.id;


--
-- Name: geocodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geocodes (
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

CREATE SEQUENCE public.geocodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geocodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geocodes_id_seq OWNED BY public.geocodes.id;


--
-- Name: infractions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.infractions (
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

CREATE SEQUENCE public.infractions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infractions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.infractions_id_seq OWNED BY public.infractions.id;


--
-- Name: inspections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inspections (
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

CREATE SEQUENCE public.inspections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inspections_id_seq OWNED BY public.inspections.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: establishments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.establishments ALTER COLUMN id SET DEFAULT nextval('public.establishments_id_seq'::regclass);


--
-- Name: geocodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geocodes ALTER COLUMN id SET DEFAULT nextval('public.geocodes_id_seq'::regclass);


--
-- Name: infractions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infractions ALTER COLUMN id SET DEFAULT nextval('public.infractions_id_seq'::regclass);


--
-- Name: inspections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspections ALTER COLUMN id SET DEFAULT nextval('public.inspections_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: establishments establishments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.establishments
    ADD CONSTRAINT establishments_pkey PRIMARY KEY (id);


--
-- Name: geocodes geocodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geocodes
    ADD CONSTRAINT geocodes_pkey PRIMARY KEY (id);


--
-- Name: infractions infractions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infractions
    ADD CONSTRAINT infractions_pkey PRIMARY KEY (id);


--
-- Name: inspections inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_pkey PRIMARY KEY (id);


--
-- Name: index_establishments_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_deleted_at ON public.establishments USING btree (deleted_at);


--
-- Name: index_establishments_on_last_closed_inspection_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_last_closed_inspection_date ON public.establishments USING btree (last_closed_inspection_date);


--
-- Name: index_establishments_on_last_conditional_inspection_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_last_conditional_inspection_date ON public.establishments USING btree (last_conditional_inspection_date);


--
-- Name: index_establishments_on_latest_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_latest_name ON public.establishments USING btree (latest_name);


--
-- Name: index_establishments_on_latlng; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_latlng ON public.establishments USING gist (latlng);


--
-- Name: index_establishments_on_max_inspection_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_max_inspection_date ON public.establishments USING btree (max_inspection_date);


--
-- Name: index_establishments_on_min_inspection_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_establishments_on_min_inspection_date ON public.establishments USING btree (min_inspection_date);


--
-- Name: index_infractions_on_inspection_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_infractions_on_inspection_id ON public.infractions USING btree (inspection_id);


--
-- Name: index_inspections_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inspections_on_date ON public.inspections USING btree (date);


--
-- Name: index_inspections_on_establishment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inspections_on_establishment_id ON public.inspections USING btree (establishment_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20111130195323'),
('20111202170638'),
('20111205223704'),
('20120417224952'),
('20121111072059'),
('20121111075800'),
('20121112065027'),
('20121114030257'),
('20121117040447'),
('20121117062637'),
('20121117170332'),
('20121117211553'),
('20121117212248'),
('20121117213519'),
('20121117222003'),
('20121207041154'),
('20130131122838'),
('20150621165743'),
('20150622001914'),
('20230701205846'),
('20230704184752');


