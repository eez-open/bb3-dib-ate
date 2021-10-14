--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.20
-- Dumped by pg_dump version 12.4

-- Started on 2021-10-14 10:07:38

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
-- TOC entry 568 (class 1247 OID 16408)
-- Name: module_types; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.module_types AS ENUM (
    'DCP405',
    'DCM224',
    'MIO168',
    'SMX46',
    'PREL6',
    'MUX14D'
);


ALTER TYPE public.module_types OWNER TO postgres;

--
-- TOC entry 573 (class 1247 OID 16450)
-- Name: test_result; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.test_result AS ENUM (
    'Success',
    'Error'
);


ALTER TYPE public.test_result OWNER TO postgres;

--
-- TOC entry 191 (class 1255 OID 16539)
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: martin
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO martin;

SET default_tablespace = '';

--
-- TOC entry 189 (class 1259 OID 16516)
-- Name: cal_params; Type: TABLE; Schema: public; Owner: martin
--

CREATE TABLE public.cal_params (
    channel integer NOT NULL,
    module_id bigint NOT NULL,
    params text NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.cal_params OWNER TO martin;

--
-- TOC entry 190 (class 1259 OID 16564)
-- Name: mio_cal_params; Type: TABLE; Schema: public; Owner: martin
--

CREATE TABLE public.mio_cal_params (
    type text NOT NULL,
    channel integer NOT NULL,
    mode text NOT NULL,
    range integer NOT NULL,
    module_id bigint NOT NULL,
    params text NOT NULL,
    test1 real NOT NULL,
    test2 real NOT NULL,
    test3 real NOT NULL,
    meas1 real NOT NULL,
    meas2 real NOT NULL,
    meas3 real NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.mio_cal_params OWNER TO martin;

--
-- TOC entry 185 (class 1259 OID 16388)
-- Name: modules; Type: TABLE; Schema: public; Owner: martin
--

CREATE TABLE public.modules (
    serial text NOT NULL,
    model public.module_types NOT NULL,
    created_at timestamp with time zone NOT NULL,
    note text,
    id bigint NOT NULL,
    version text NOT NULL,
    added_by text DEFAULT 'unknown'::text NOT NULL
);


ALTER TABLE public.modules OWNER TO martin;

--
-- TOC entry 188 (class 1259 OID 16455)
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: martin
--

CREATE SEQUENCE public.modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.modules_id_seq OWNER TO martin;

--
-- TOC entry 2176 (class 0 OID 0)
-- Dependencies: 188
-- Name: modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: martin
--

ALTER SEQUENCE public.modules_id_seq OWNED BY public.modules.id;


--
-- TOC entry 187 (class 1259 OID 16421)
-- Name: tests; Type: TABLE; Schema: public; Owner: martin
--

CREATE TABLE public.tests (
    id bigint NOT NULL,
    tester text NOT NULL,
    test_executed text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    result public.test_result NOT NULL,
    error_test text,
    error_test_step text,
    error_message text,
    note text,
    module_id bigint NOT NULL
);


ALTER TABLE public.tests OWNER TO martin;

--
-- TOC entry 186 (class 1259 OID 16419)
-- Name: tests_id_seq; Type: SEQUENCE; Schema: public; Owner: martin
--

CREATE SEQUENCE public.tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tests_id_seq OWNER TO martin;

--
-- TOC entry 2179 (class 0 OID 0)
-- Dependencies: 186
-- Name: tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: martin
--

ALTER SEQUENCE public.tests_id_seq OWNED BY public.tests.id;


--
-- TOC entry 2030 (class 2604 OID 16457)
-- Name: modules id; Type: DEFAULT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.modules ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);


--
-- TOC entry 2032 (class 2604 OID 16424)
-- Name: tests id; Type: DEFAULT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.tests ALTER COLUMN id SET DEFAULT nextval('public.tests_id_seq'::regclass);


--
-- TOC entry 2044 (class 2606 OID 16571)
-- Name: mio_cal_params mio_cal_params_module_id_channel_unique_key; Type: CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.mio_cal_params
    ADD CONSTRAINT mio_cal_params_module_id_channel_unique_key UNIQUE (channel, type, mode, range, module_id);


--
-- TOC entry 2042 (class 2606 OID 16523)
-- Name: cal_params module_id_channel_unique_key; Type: CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.cal_params
    ADD CONSTRAINT module_id_channel_unique_key UNIQUE (channel, module_id);


--
-- TOC entry 2034 (class 2606 OID 16466)
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2036 (class 2606 OID 16474)
-- Name: modules modules_type_serial_unique_key; Type: CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_type_serial_unique_key UNIQUE (model, serial);


--
-- TOC entry 2040 (class 2606 OID 16429)
-- Name: tests tests_pkey; Type: CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tests_pkey PRIMARY KEY (id);


--
-- TOC entry 2037 (class 1259 OID 16448)
-- Name: fki_tester_fkey; Type: INDEX; Schema: public; Owner: martin
--

CREATE INDEX fki_tester_fkey ON public.tests USING btree (tester);


--
-- TOC entry 2038 (class 1259 OID 16472)
-- Name: fki_tester_id_fkey; Type: INDEX; Schema: public; Owner: martin
--

CREATE INDEX fki_tester_id_fkey ON public.tests USING btree (module_id);


--
-- TOC entry 2048 (class 2620 OID 16540)
-- Name: cal_params cal_params_set_updated_at; Type: TRIGGER; Schema: public; Owner: martin
--

CREATE TRIGGER cal_params_set_updated_at BEFORE UPDATE ON public.cal_params FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_timestamp();


--
-- TOC entry 2050 (class 2620 OID 16577)
-- Name: mio_cal_params mio_cal_params_set_updated_at; Type: TRIGGER; Schema: public; Owner: martin
--

CREATE TRIGGER mio_cal_params_set_updated_at BEFORE INSERT OR UPDATE ON public.mio_cal_params FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_timestamp();


--
-- TOC entry 2049 (class 2620 OID 16542)
-- Name: cal_params set_timestamp; Type: TRIGGER; Schema: public; Owner: martin
--

CREATE TRIGGER set_timestamp BEFORE INSERT ON public.cal_params FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_timestamp();


--
-- TOC entry 2047 (class 2606 OID 16572)
-- Name: mio_cal_params mio_cal_params_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.mio_cal_params
    ADD CONSTRAINT mio_cal_params_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- TOC entry 2046 (class 2606 OID 16524)
-- Name: cal_params module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.cal_params
    ADD CONSTRAINT module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id);


--
-- TOC entry 2045 (class 2606 OID 16467)
-- Name: tests tester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: martin
--

ALTER TABLE ONLY public.tests
    ADD CONSTRAINT tester_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) NOT VALID;


--
-- TOC entry 2173 (class 0 OID 0)
-- Dependencies: 189
-- Name: TABLE cal_params; Type: ACL; Schema: public; Owner: martin
--

GRANT SELECT ON TABLE public.cal_params TO joomla;
GRANT ALL ON TABLE public.cal_params TO dm;
GRANT ALL ON TABLE public.cal_params TO denis;


--
-- TOC entry 2174 (class 0 OID 0)
-- Dependencies: 190
-- Name: TABLE mio_cal_params; Type: ACL; Schema: public; Owner: martin
--

GRANT SELECT ON TABLE public.mio_cal_params TO joomla;
GRANT ALL ON TABLE public.mio_cal_params TO dm;
GRANT ALL ON TABLE public.mio_cal_params TO denis;


--
-- TOC entry 2175 (class 0 OID 0)
-- Dependencies: 185
-- Name: TABLE modules; Type: ACL; Schema: public; Owner: martin
--

GRANT ALL ON TABLE public.modules TO denis;
GRANT ALL ON TABLE public.modules TO dm;
GRANT SELECT ON TABLE public.modules TO joomla;


--
-- TOC entry 2177 (class 0 OID 0)
-- Dependencies: 188
-- Name: SEQUENCE modules_id_seq; Type: ACL; Schema: public; Owner: martin
--

GRANT SELECT,USAGE ON SEQUENCE public.modules_id_seq TO denis;
GRANT SELECT,USAGE ON SEQUENCE public.modules_id_seq TO dm;


--
-- TOC entry 2178 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE tests; Type: ACL; Schema: public; Owner: martin
--

GRANT ALL ON TABLE public.tests TO denis;
GRANT ALL ON TABLE public.tests TO dm;
GRANT SELECT ON TABLE public.tests TO joomla;


--
-- TOC entry 2180 (class 0 OID 0)
-- Dependencies: 186
-- Name: SEQUENCE tests_id_seq; Type: ACL; Schema: public; Owner: martin
--

GRANT SELECT,USAGE ON SEQUENCE public.tests_id_seq TO denis;
GRANT SELECT,USAGE ON SEQUENCE public.tests_id_seq TO dm;


-- Completed on 2021-10-14 10:07:41

--
-- PostgreSQL database dump complete
--

