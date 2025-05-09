--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Debian 14.8-1.pgdg120+1)
-- Dumped by pg_dump version 14.8 (Debian 14.8-1.pgdg120+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: vendas; Type: TABLE; Schema: public; Owner: analista
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    data_venda date NOT NULL,
    produto character varying(100) NOT NULL,
    categoria character varying(50) NOT NULL,
    valor numeric(10,2) NOT NULL,
    quantidade integer NOT NULL
);


ALTER TABLE public.vendas OWNER TO analista;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: analista
--

CREATE SEQUENCE public.vendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendas_id_seq OWNER TO analista;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: analista
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: analista
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Data for Name: vendas; Type: TABLE DATA; Schema: public; Owner: analista
--

COPY public.vendas (id, data_venda, produto, categoria, valor, quantidade) FROM stdin;
1	2025-01-15	Curso Python	Educacao	197.00	45
2	2025-01-20	Assinatura BI	Software	89.90	28
3	2025-02-05	Consultoria	Servicos	1200.00	3
4	2025-02-12	Curso SQL	Educacao	147.00	52
5	2025-03-01	Licenca Tableau	Software	999.00	15
\.


--
-- Name: vendas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: analista
--

SELECT pg_catalog.setval('public.vendas_id_seq', 5, true);


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: analista
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

