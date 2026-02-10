--
-- PostgreSQL database dump
--

\restrict 1CmpQHRBQt7Pw8hPBkQP0cbBm0HSjJioOKwNe3uCmXjU8LMuOPpr5m4hhcJePfx

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.6 (Homebrew)

-- Started on 2026-02-09 07:05:15 MSK

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 91897)
-- Name: arm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arm (
    id_arm integer NOT NULL,
    name character varying(200) NOT NULL,
    id_user integer,
    id_location integer NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.arm OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 91903)
-- Name: arm_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arm_history (
    id_history integer NOT NULL,
    id_arm integer NOT NULL,
    changed_by integer,
    change_type character varying(50) NOT NULL,
    old_value text,
    new_value text,
    change_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    comment text
);


ALTER TABLE public.arm_history OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 91909)
-- Name: arm_history_id_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.arm_history_id_history_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.arm_history_id_history_seq OWNER TO postgres;

--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 219
-- Name: arm_history_id_history_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.arm_history_id_history_seq OWNED BY public.arm_history.id_history;


--
-- TOC entry 220 (class 1259 OID 91910)
-- Name: arm_id_arm_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.arm_id_arm_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.arm_id_arm_seq OWNER TO postgres;

--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 220
-- Name: arm_id_arm_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.arm_id_arm_seq OWNED BY public.arm.id_arm;


--
-- TOC entry 221 (class 1259 OID 91911)
-- Name: desk_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desk_attachments (
    attach_id integer NOT NULL,
    path character varying(500) NOT NULL,
    name character varying(255) NOT NULL,
    extension character varying(10) NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desk_attachments OWNER TO postgres;

--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN desk_attachments.path; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.desk_attachments.path IS 'Путь к файлу';


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN desk_attachments.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.desk_attachments.name IS 'Имя файла';


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN desk_attachments.extension; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.desk_attachments.extension IS 'Расширение файла';


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 221
-- Name: COLUMN desk_attachments.created_at; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.desk_attachments.created_at IS 'Дата создания';


--
-- TOC entry 222 (class 1259 OID 91917)
-- Name: desk_attachments_attach_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.desk_attachments_attach_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desk_attachments_attach_id_seq OWNER TO postgres;

--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 222
-- Name: desk_attachments_attach_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.desk_attachments_attach_id_seq OWNED BY public.desk_attachments.attach_id;


--
-- TOC entry 223 (class 1259 OID 91918)
-- Name: dic_task_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dic_task_status (
    id_status integer NOT NULL,
    status_name character varying(50) NOT NULL
);


ALTER TABLE public.dic_task_status OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 91921)
-- Name: dic_task_status_id_status_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dic_task_status_id_status_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dic_task_status_id_status_seq OWNER TO postgres;

--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 224
-- Name: dic_task_status_id_status_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dic_task_status_id_status_seq OWNED BY public.dic_task_status.id_status;


--
-- TOC entry 225 (class 1259 OID 91922)
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id_location integer NOT NULL,
    name character varying(100) NOT NULL,
    location_type character varying(50) NOT NULL,
    floor integer,
    description text,
    CONSTRAINT chk_location_type CHECK (((location_type)::text = ANY (ARRAY[('кабинет'::character varying)::text, ('склад'::character varying)::text, ('серверная'::character varying)::text, ('лаборатория'::character varying)::text, ('другое'::character varying)::text])))
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 91928)
-- Name: locations_id_location_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_location_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_location_seq OWNER TO postgres;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 226
-- Name: locations_id_location_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_location_seq OWNED BY public.locations.id_location;


--
-- TOC entry 227 (class 1259 OID 91929)
-- Name: migration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migration (
    version character varying(180) NOT NULL,
    apply_time integer
);


ALTER TABLE public.migration OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 91932)
-- Name: part_char_values; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.part_char_values (
    id_part_char integer NOT NULL,
    id_part integer NOT NULL,
    id_char integer NOT NULL,
    value_text text,
    id_arm integer NOT NULL
);


ALTER TABLE public.part_char_values OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 91937)
-- Name: part_char_values_id_part_char_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.part_char_values_id_part_char_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.part_char_values_id_part_char_seq OWNER TO postgres;

--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 229
-- Name: part_char_values_id_part_char_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.part_char_values_id_part_char_seq OWNED BY public.part_char_values.id_part_char;


--
-- TOC entry 230 (class 1259 OID 91938)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_role integer NOT NULL,
    role_name character varying
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 91943)
-- Name: roles_id_role_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN id_role ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_id_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 91944)
-- Name: spr_char; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spr_char (
    id_char integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    measurement_unit character varying
);


ALTER TABLE public.spr_char OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 91949)
-- Name: spr_char_id_char_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.spr_char_id_char_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.spr_char_id_char_seq OWNER TO postgres;

--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 233
-- Name: spr_char_id_char_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.spr_char_id_char_seq OWNED BY public.spr_char.id_char;


--
-- TOC entry 234 (class 1259 OID 91950)
-- Name: spr_parts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spr_parts (
    id_part integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    CONSTRAINT chk_name_not_empty CHECK ((length(TRIM(BOTH FROM name)) > 0))
);


ALTER TABLE public.spr_parts OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 91956)
-- Name: spr_parts_id_part_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.spr_parts_id_part_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.spr_parts_id_part_seq OWNER TO postgres;

--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 235
-- Name: spr_parts_id_part_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.spr_parts_id_part_seq OWNED BY public.spr_parts.id_part;


--
-- TOC entry 236 (class 1259 OID 91957)
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id integer NOT NULL,
    id_status integer NOT NULL,
    description text NOT NULL,
    id_user integer NOT NULL,
    date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_time_update timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    comment text,
    executor_id integer,
    attachments text
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 236
-- Name: COLUMN tasks.executor_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.tasks.executor_id IS 'ID исполнителя';


--
-- TOC entry 237 (class 1259 OID 91964)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tasks_id_seq OWNER TO postgres;

--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 237
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- TOC entry 238 (class 1259 OID 91965)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user integer NOT NULL,
    full_name character varying(200) NOT NULL,
    "position" character varying(100),
    department character varying(100),
    email character varying(100),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    password character varying(100),
    auth_key character varying(32) DEFAULT NULL::character varying,
    access_token character varying(255) DEFAULT NULL::character varying,
    password_reset_token character varying(255) DEFAULT NULL::character varying,
    id_role integer NOT NULL,
    CONSTRAINT chk_fullname_not_empty CHECK ((length(TRIM(BOTH FROM full_name)) > 0))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.users IS 'Работники организации';


--
-- TOC entry 239 (class 1259 OID 91975)
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_user_seq OWNER TO postgres;

--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 239
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_user_seq OWNED BY public.users.id_user;


--
-- TOC entry 3504 (class 2604 OID 91976)
-- Name: arm id_arm; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm ALTER COLUMN id_arm SET DEFAULT nextval('public.arm_id_arm_seq'::regclass);


--
-- TOC entry 3506 (class 2604 OID 91977)
-- Name: arm_history id_history; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm_history ALTER COLUMN id_history SET DEFAULT nextval('public.arm_history_id_history_seq'::regclass);


--
-- TOC entry 3508 (class 2604 OID 91978)
-- Name: desk_attachments attach_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desk_attachments ALTER COLUMN attach_id SET DEFAULT nextval('public.desk_attachments_attach_id_seq'::regclass);


--
-- TOC entry 3510 (class 2604 OID 91979)
-- Name: dic_task_status id_status; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dic_task_status ALTER COLUMN id_status SET DEFAULT nextval('public.dic_task_status_id_status_seq'::regclass);


--
-- TOC entry 3511 (class 2604 OID 91980)
-- Name: locations id_location; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id_location SET DEFAULT nextval('public.locations_id_location_seq'::regclass);


--
-- TOC entry 3512 (class 2604 OID 91981)
-- Name: part_char_values id_part_char; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.part_char_values ALTER COLUMN id_part_char SET DEFAULT nextval('public.part_char_values_id_part_char_seq'::regclass);


--
-- TOC entry 3513 (class 2604 OID 91982)
-- Name: spr_char id_char; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spr_char ALTER COLUMN id_char SET DEFAULT nextval('public.spr_char_id_char_seq'::regclass);


--
-- TOC entry 3514 (class 2604 OID 91983)
-- Name: spr_parts id_part; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spr_parts ALTER COLUMN id_part SET DEFAULT nextval('public.spr_parts_id_part_seq'::regclass);


--
-- TOC entry 3515 (class 2604 OID 91984)
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- TOC entry 3518 (class 2604 OID 91985)
-- Name: users id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id_user SET DEFAULT nextval('public.users_id_user_seq'::regclass);


--
-- TOC entry 3713 (class 0 OID 91897)
-- Dependencies: 217
-- Data for Name: arm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arm (id_arm, name, id_user, id_location, description, created_at) FROM stdin;
103	АРМ-301	301	183	Рабочее место пользователя	2025-10-27 11:44:19.826015
104	АРМ-302	302	184	Рабочее место пользователя	2025-10-27 11:44:19.826015
105	АРМ-303	303	185	Рабочее место пользователя	2025-10-27 11:44:19.826015
106	АРМ-304	304	186	Рабочее место пользователя	2025-10-27 11:44:19.826015
107	АРМ-305	305	187	Рабочее место пользователя	2025-10-27 11:44:19.826015
108	АРМ-306	306	188	Рабочее место пользователя	2025-10-27 11:44:19.826015
109	АРМ-307	307	189	Рабочее место пользователя	2025-10-27 11:44:19.826015
110	АРМ-308	308	190	Рабочее место пользователя	2025-10-27 11:44:19.826015
111	АРМ-309	309	191	Рабочее место пользователя	2025-10-27 11:44:19.826015
112	АРМ-310	310	192	Рабочее место пользователя	2025-10-27 11:44:19.826015
113	АРМ-311	311	193	Рабочее место пользователя	2025-10-27 11:44:19.826015
114	АРМ-312	312	194	Рабочее место пользователя	2025-10-27 11:44:19.826015
115	АРМ-313	313	195	Рабочее место пользователя	2025-10-27 11:44:19.826015
116	АРМ-314	314	196	Рабочее место пользователя	2025-10-27 11:44:19.826015
117	АРМ-315	315	197	Рабочее место пользователя	2025-10-27 11:44:19.826015
118	АРМ-316	316	198	Рабочее место пользователя	2025-10-27 11:44:19.826015
119	АРМ-317	317	199	Рабочее место пользователя	2025-10-27 11:44:19.826015
120	АРМ-318	318	200	Рабочее место пользователя	2025-10-27 11:44:19.826015
121	АРМ-319	319	201	Рабочее место пользователя	2025-10-27 11:44:19.826015
122	АРМ-320	320	202	Рабочее место пользователя	2025-10-27 11:44:19.826015
123	АРМ-321	321	203	Рабочее место пользователя	2025-10-27 11:44:19.826015
124	АРМ-322	322	204	Рабочее место пользователя	2025-10-27 11:44:19.826015
125	АРМ-323	323	205	Рабочее место пользователя	2025-10-27 11:44:19.826015
126	АРМ-324	324	206	Рабочее место пользователя	2025-10-27 11:44:19.826015
127	АРМ-325	325	207	Рабочее место пользователя	2025-10-27 11:44:19.826015
128	АРМ-326	326	208	Рабочее место пользователя	2025-10-27 11:44:19.826015
129	АРМ-327	327	209	Рабочее место пользователя	2025-10-27 11:44:19.826015
130	АРМ-328	328	210	Рабочее место пользователя	2025-10-27 11:44:19.826015
131	АРМ-329	329	211	Рабочее место пользователя	2025-10-27 11:44:19.826015
132	АРМ-330	330	212	Рабочее место пользователя	2025-10-27 11:44:19.826015
133	АРМ-331	331	213	Рабочее место пользователя	2025-10-27 11:44:19.826015
134	АРМ-332	332	214	Рабочее место пользователя	2025-10-27 11:44:19.826015
135	АРМ-333	333	215	Рабочее место пользователя	2025-10-27 11:44:19.826015
136	АРМ-334	334	216	Рабочее место пользователя	2025-10-27 11:44:19.826015
137	АРМ-335	335	217	Рабочее место пользователя	2025-10-27 11:44:19.826015
138	АРМ-336	336	218	Рабочее место пользователя	2025-10-27 11:44:19.826015
139	АРМ-337	337	219	Рабочее место пользователя	2025-10-27 11:44:19.826015
140	АРМ-338	338	220	Рабочее место пользователя	2025-10-27 11:44:19.826015
141	АРМ-339	339	221	Рабочее место пользователя	2025-10-27 11:44:19.826015
142	АРМ-340	340	222	Рабочее место пользователя	2025-10-27 11:44:19.826015
143	АРМ-341	341	223	Рабочее место пользователя	2025-10-27 11:44:19.826015
144	АРМ-342	342	224	Рабочее место пользователя	2025-10-27 11:44:19.826015
145	АРМ-343	343	225	Рабочее место пользователя	2025-10-27 11:44:19.826015
146	АРМ-344	344	226	Рабочее место пользователя	2025-10-27 11:44:19.826015
147	АРМ-345	345	227	Рабочее место пользователя	2025-10-27 11:44:19.826015
148	АРМ-346	346	228	Рабочее место пользователя	2025-10-27 11:44:19.826015
149	АРМ-347	347	229	Рабочее место пользователя	2025-10-27 11:44:19.826015
150	АРМ-348	348	230	Рабочее место пользователя	2025-10-27 11:44:19.826015
151	АРМ-349	349	231	Рабочее место пользователя	2025-10-27 11:44:19.826015
152	АРМ-350	350	232	Рабочее место пользователя	2025-10-27 11:44:19.826015
153	АРМ-351	351	233	Рабочее место пользователя	2025-10-27 11:44:19.826015
154	АРМ-352	352	234	Рабочее место пользователя	2025-10-27 11:44:19.826015
155	АРМ-353	353	235	Рабочее место пользователя	2025-10-27 11:44:19.826015
156	АРМ-354	354	236	Рабочее место пользователя	2025-10-27 11:44:19.826015
157	АРМ-355	355	237	Рабочее место пользователя	2025-10-27 11:44:19.826015
158	АРМ-356	356	238	Рабочее место пользователя	2025-10-27 11:44:19.826015
159	АРМ-357	357	239	Рабочее место пользователя	2025-10-27 11:44:19.826015
160	АРМ-358	358	240	Рабочее место пользователя	2025-10-27 11:44:19.826015
161	АРМ-359	359	241	Рабочее место пользователя	2025-10-27 11:44:19.826015
162	АРМ-360	360	242	Рабочее место пользователя	2025-10-27 11:44:19.826015
163	АРМ-361	361	243	Рабочее место пользователя	2025-10-27 11:44:19.826015
164	АРМ-362	362	244	Рабочее место пользователя	2025-10-27 11:44:19.826015
165	АРМ-363	363	245	Рабочее место пользователя	2025-10-27 11:44:19.826015
166	АРМ-364	364	246	Рабочее место пользователя	2025-10-27 11:44:19.826015
167	АРМ-365	365	247	Рабочее место пользователя	2025-10-27 11:44:19.826015
168	АРМ-366	366	248	Рабочее место пользователя	2025-10-27 11:44:19.826015
169	АРМ-367	367	249	Рабочее место пользователя	2025-10-27 11:44:19.826015
170	АРМ-368	368	250	Рабочее место пользователя	2025-10-27 11:44:19.826015
171	АРМ-369	369	251	Рабочее место пользователя	2025-10-27 11:44:19.826015
172	АРМ-370	370	252	Рабочее место пользователя	2025-10-27 11:44:19.826015
173	АРМ-371	371	253	Рабочее место пользователя	2025-10-27 11:44:19.826015
174	АРМ-372	372	254	Рабочее место пользователя	2025-10-27 11:44:19.826015
175	АРМ-373	373	255	Рабочее место пользователя	2025-10-27 11:44:19.826015
176	АРМ-374	374	256	Рабочее место пользователя	2025-10-27 11:44:19.826015
177	АРМ-375	375	257	Рабочее место пользователя	2025-10-27 11:44:19.826015
178	АРМ-376	376	258	Рабочее место пользователя	2025-10-27 11:44:19.826015
179	АРМ-377	377	259	Рабочее место пользователя	2025-10-27 11:44:19.826015
180	АРМ-378	378	260	Рабочее место пользователя	2025-10-27 11:44:19.826015
181	АРМ-379	379	261	Рабочее место пользователя	2025-10-27 11:44:19.826015
182	АРМ-380	380	262	Рабочее место пользователя	2025-10-27 11:44:19.826015
183	АРМ-381	381	263	Рабочее место пользователя	2025-10-27 11:44:19.826015
184	АРМ-382	382	264	Рабочее место пользователя	2025-10-27 11:44:19.826015
185	АРМ-383	383	265	Рабочее место пользователя	2025-10-27 11:44:19.826015
186	АРМ-384	384	266	Рабочее место пользователя	2025-10-27 11:44:19.826015
187	АРМ-385	385	267	Рабочее место пользователя	2025-10-27 11:44:19.826015
188	АРМ-386	386	268	Рабочее место пользователя	2025-10-27 11:44:19.826015
189	АРМ-387	387	269	Рабочее место пользователя	2025-10-27 11:44:19.826015
190	АРМ-388	388	270	Рабочее место пользователя	2025-10-27 11:44:19.826015
191	АРМ-389	389	271	Рабочее место пользователя	2025-10-27 11:44:19.826015
192	АРМ-390	390	272	Рабочее место пользователя	2025-10-27 11:44:19.826015
193	АРМ-391	391	273	Рабочее место пользователя	2025-10-27 11:44:19.826015
194	АРМ-392	392	274	Рабочее место пользователя	2025-10-27 11:44:19.826015
195	АРМ-393	393	275	Рабочее место пользователя	2025-10-27 11:44:19.826015
196	АРМ-394	394	276	Рабочее место пользователя	2025-10-27 11:44:19.826015
197	АРМ-395	395	277	Рабочее место пользователя	2025-10-27 11:44:19.826015
198	АРМ-396	396	278	Рабочее место пользователя	2025-10-27 11:44:19.826015
199	АРМ-397	397	279	Рабочее место пользователя	2025-10-27 11:44:19.826015
200	АРМ-398	398	280	Рабочее место пользователя	2025-10-27 11:44:19.826015
201	АРМ-399	399	281	Рабочее место пользователя	2025-10-27 11:44:19.826015
202	АРМ-400	400	282	Рабочее место пользователя	2025-10-27 11:44:19.826015
203	ICL i5	407	183	Тестик	2025-11-04 23:59:54.064911
204	ICL i5	401	205		2025-11-05 18:48:48.992747
\.


--
-- TOC entry 3714 (class 0 OID 91903)
-- Dependencies: 218
-- Data for Name: arm_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arm_history (id_history, id_arm, changed_by, change_type, old_value, new_value, change_date, comment) FROM stdin;
\.


--
-- TOC entry 3717 (class 0 OID 91911)
-- Dependencies: 221
-- Data for Name: desk_attachments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desk_attachments (attach_id, path, name, extension, created_at) FROM stdin;
1	/uploads/tasks/1761746108_pngwing.com.png	pngwing.com.png	png	2025-10-29 16:55:09
2	/uploads/tasks/1761746142_pngwing.com(2).png	pngwing.com(2).png	png	2025-10-29 16:55:42
3	/uploads/tasks/1761746903_pngwing.com(2).png	pngwing.com(2).png	png	2025-10-29 17:08:24
4	/uploads/tasks/1761750249_pngwing.com(2).png	pngwing.com(2).png	png	2025-10-29 18:04:09
5	/uploads/tasks/1762020718_69064d6e2cefc_uch_v1.txt	uch_v1.txt	txt	2025-11-01 21:11:58
6	/uploads/tasks/1762021317_69064fc54f70f_uch_v1.txt	uch_v1.txt	txt	2025-11-01 21:21:57
7	/uploads/tasks/1762021793_690651a171e08_Физическая_исп.docx	Физическая_исп.docx	docx	2025-11-01 21:29:53
8	/uploads/tasks/1762021931_6906522b2e8c9_op_r_ddl_v5.txt	op_r_ddl_v5.txt	txt	2025-11-01 21:32:11
9	/uploads/tasks/1762022044_6906529ca0b61_uch_v1.txt	uch_v1.txt	txt	2025-11-01 21:34:05
10	/uploads/tasks/1762022058_690652aabda2b_uch_v1.txt	uch_v1.txt	txt	2025-11-01 21:34:19
11	/uploads/tasks/1762023989_69065a359f43e_форель.png	форель.png	png	2025-11-01 22:06:30
12	/uploads/tasks/1762024774_69065d465dbed_форель.png	форель.png	png	2025-11-01 22:19:34
13	/uploads/tasks/1762024858_69065d9a60c18_j_s.png	j_s.png	png	2025-11-01 22:20:58
14	/uploads/tasks/1762024858_69065d9a62e4a_форель.png	форель.png	png	2025-11-01 22:20:58
15	/uploads/tasks/1762203057_690915b175243_j_s.png	j_s.png	png	2025-11-03 23:50:57
16	/uploads/tasks/1762203057_690915b177879_форель.png	форель.png	png	2025-11-03 23:50:57
\.


--
-- TOC entry 3719 (class 0 OID 91918)
-- Dependencies: 223
-- Data for Name: dic_task_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dic_task_status (id_status, status_name) FROM stdin;
3	Отменено
1	Открыта
2	В работе
6	Завершено
\.


--
-- TOC entry 3721 (class 0 OID 91922)
-- Dependencies: 225
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id_location, name, location_type, floor, description) FROM stdin;
183	Кабинет 100	кабинет	1	Рабочий кабинет
184	Кабинет 101	кабинет	1	Рабочий кабинет
185	Кабинет 102	кабинет	1	Рабочий кабинет
186	Кабинет 103	кабинет	1	Рабочий кабинет
187	Кабинет 104	кабинет	1	Рабочий кабинет
188	Кабинет 105	кабинет	1	Рабочий кабинет
189	Кабинет 106	кабинет	1	Рабочий кабинет
190	Кабинет 107	кабинет	1	Рабочий кабинет
191	Кабинет 108	кабинет	1	Рабочий кабинет
192	Кабинет 109	кабинет	1	Рабочий кабинет
193	Кабинет 110	кабинет	1	Рабочий кабинет
194	Кабинет 111	кабинет	1	Рабочий кабинет
195	Кабинет 112	кабинет	1	Рабочий кабинет
196	Кабинет 113	кабинет	1	Рабочий кабинет
197	Кабинет 114	кабинет	1	Рабочий кабинет
198	Кабинет 115	кабинет	1	Рабочий кабинет
199	Кабинет 116	кабинет	1	Рабочий кабинет
200	Кабинет 117	кабинет	1	Рабочий кабинет
201	Кабинет 118	кабинет	1	Рабочий кабинет
202	Кабинет 119	кабинет	1	Рабочий кабинет
203	Кабинет 120	кабинет	1	Рабочий кабинет
204	Кабинет 199	кабинет	1	Рабочий кабинет
205	Кабинет 200	кабинет	2	Рабочий кабинет
206	Кабинет 201	кабинет	2	Рабочий кабинет
207	Кабинет 202	кабинет	2	Рабочий кабинет
208	Кабинет 203	кабинет	2	Рабочий кабинет
209	Кабинет 204	кабинет	2	Рабочий кабинет
210	Кабинет 205	кабинет	2	Рабочий кабинет
211	Кабинет 206	кабинет	2	Рабочий кабинет
212	Кабинет 207	кабинет	2	Рабочий кабинет
213	Кабинет 208	кабинет	2	Рабочий кабинет
214	Кабинет 209	кабинет	2	Рабочий кабинет
215	Кабинет 210	кабинет	2	Рабочий кабинет
216	Кабинет 211	кабинет	2	Рабочий кабинет
217	Кабинет 212	кабинет	2	Рабочий кабинет
218	Кабинет 213	кабинет	2	Рабочий кабинет
219	Кабинет 214	кабинет	2	Рабочий кабинет
220	Кабинет 215	кабинет	2	Рабочий кабинет
221	Кабинет 216	кабинет	2	Рабочий кабинет
222	Кабинет 217	кабинет	2	Рабочий кабинет
223	Кабинет 218	кабинет	2	Рабочий кабинет
224	Кабинет 219	кабинет	2	Рабочий кабинет
225	Кабинет 220	кабинет	2	Рабочий кабинет
226	Кабинет 299	кабинет	2	Рабочий кабинет
227	Кабинет 300	кабинет	3	Рабочий кабинет
228	Кабинет 301	кабинет	3	Рабочий кабинет
229	Кабинет 302	кабинет	3	Рабочий кабинет
230	Кабинет 303	кабинет	3	Рабочий кабинет
231	Кабинет 304	кабинет	3	Рабочий кабинет
232	Кабинет 305	кабинет	3	Рабочий кабинет
233	Кабинет 306	кабинет	3	Рабочий кабинет
234	Кабинет 307	кабинет	3	Рабочий кабинет
235	Кабинет 308	кабинет	3	Рабочий кабинет
236	Кабинет 309	кабинет	3	Рабочий кабинет
237	Кабинет 310	кабинет	3	Рабочий кабинет
238	Кабинет 311	кабинет	3	Рабочий кабинет
239	Кабинет 312	кабинет	3	Рабочий кабинет
240	Кабинет 313	кабинет	3	Рабочий кабинет
241	Кабинет 314	кабинет	3	Рабочий кабинет
242	Кабинет 315	кабинет	3	Рабочий кабинет
243	Кабинет 316	кабинет	3	Рабочий кабинет
244	Кабинет 317	кабинет	3	Рабочий кабинет
245	Кабинет 318	кабинет	3	Рабочий кабинет
246	Кабинет 319	кабинет	3	Рабочий кабинет
247	Кабинет 320	кабинет	3	Рабочий кабинет
248	Кабинет 399	кабинет	3	Рабочий кабинет
249	Кабинет 400	кабинет	4	Рабочий кабинет
250	Кабинет 401	кабинет	4	Рабочий кабинет
251	Кабинет 402	кабинет	4	Рабочий кабинет
252	Кабинет 403	кабинет	4	Рабочий кабинет
253	Кабинет 404	кабинет	4	Рабочий кабинет
254	Кабинет 405	кабинет	4	Рабочий кабинет
255	Кабинет 406	кабинет	4	Рабочий кабинет
256	Кабинет 407	кабинет	4	Рабочий кабинет
257	Кабинет 408	кабинет	4	Рабочий кабинет
258	Кабинет 409	кабинет	4	Рабочий кабинет
259	Кабинет 410	кабинет	4	Рабочий кабинет
260	Кабинет 411	кабинет	4	Рабочий кабинет
261	Кабинет 412	кабинет	4	Рабочий кабинет
262	Кабинет 413	кабинет	4	Рабочий кабинет
263	Кабинет 414	кабинет	4	Рабочий кабинет
264	Кабинет 415	кабинет	4	Рабочий кабинет
265	Кабинет 416	кабинет	4	Рабочий кабинет
266	Кабинет 417	кабинет	4	Рабочий кабинет
267	Кабинет 418	кабинет	4	Рабочий кабинет
268	Кабинет 419	кабинет	4	Рабочий кабинет
269	Кабинет 420	кабинет	4	Рабочий кабинет
270	Кабинет 499	кабинет	4	Рабочий кабинет
271	Кабинет 500	кабинет	5	Рабочий кабинет
272	Кабинет 501	кабинет	5	Рабочий кабинет
273	Кабинет 502	кабинет	5	Рабочий кабинет
274	Кабинет 503	кабинет	5	Рабочий кабинет
275	Кабинет 504	кабинет	5	Рабочий кабинет
276	Кабинет 505	кабинет	5	Рабочий кабинет
277	Кабинет 506	кабинет	5	Рабочий кабинет
278	Кабинет 507	кабинет	5	Рабочий кабинет
279	Кабинет 508	кабинет	5	Рабочий кабинет
280	Кабинет 509	кабинет	5	Рабочий кабинет
281	Кабинет 510	кабинет	5	Рабочий кабинет
282	Кабинет 511	кабинет	5	Рабочий кабинет
283	Кабинет 512	кабинет	5	Рабочий кабинет
284	Кабинет 513	кабинет	5	Рабочий кабинет
285	Кабинет 514	кабинет	5	Рабочий кабинет
286	Кабинет 515	кабинет	5	Рабочий кабинет
287	Кабинет 516	кабинет	5	Рабочий кабинет
288	Кабинет 517	кабинет	5	Рабочий кабинет
289	Кабинет 518	кабинет	5	Рабочий кабинет
290	Кабинет 519	кабинет	5	Рабочий кабинет
291	Кабинет 520	кабинет	5	Рабочий кабинет
292	Кабинет 599	кабинет	5	Рабочий кабинет
293	Кабинет 600	кабинет	6	Рабочий кабинет
294	Кабинет 601	кабинет	6	Рабочий кабинет
295	Кабинет 602	кабинет	6	Рабочий кабинет
296	Кабинет 603	кабинет	6	Рабочий кабинет
297	Кабинет 604	кабинет	6	Рабочий кабинет
298	Кабинет 605	кабинет	6	Рабочий кабинет
299	Кабинет 606	кабинет	6	Рабочий кабинет
300	Кабинет 607	кабинет	6	Рабочий кабинет
301	Кабинет 608	кабинет	6	Рабочий кабинет
302	Кабинет 609	кабинет	6	Рабочий кабинет
303	Кабинет 610	кабинет	6	Рабочий кабинет
304	Кабинет 611	кабинет	6	Рабочий кабинет
305	Кабинет 612	кабинет	6	Рабочий кабинет
306	Кабинет 613	кабинет	6	Рабочий кабинет
307	Кабинет 614	кабинет	6	Рабочий кабинет
308	Кабинет 615	кабинет	6	Рабочий кабинет
309	Кабинет 616	кабинет	6	Рабочий кабинет
310	Кабинет 617	кабинет	6	Рабочий кабинет
311	Кабинет 618	кабинет	6	Рабочий кабинет
312	Кабинет 619	кабинет	6	Рабочий кабинет
313	Кабинет 620	кабинет	6	Рабочий кабинет
314	Кабинет 699	кабинет	6	Рабочий кабинет
315	Кабинет 700	кабинет	7	Рабочий кабинет
316	Кабинет 701	кабинет	7	Рабочий кабинет
317	Кабинет 702	кабинет	7	Рабочий кабинет
318	Кабинет 703	кабинет	7	Рабочий кабинет
319	Кабинет 704	кабинет	7	Рабочий кабинет
320	Кабинет 705	кабинет	7	Рабочий кабинет
321	Кабинет 706	кабинет	7	Рабочий кабинет
322	Кабинет 707	кабинет	7	Рабочий кабинет
323	Кабинет 708	кабинет	7	Рабочий кабинет
324	Кабинет 709	кабинет	7	Рабочий кабинет
325	Кабинет 710	кабинет	7	Рабочий кабинет
326	Кабинет 711	кабинет	7	Рабочий кабинет
327	Кабинет 712	кабинет	7	Рабочий кабинет
328	Кабинет 713	кабинет	7	Рабочий кабинет
329	Кабинет 714	кабинет	7	Рабочий кабинет
330	Кабинет 715	кабинет	7	Рабочий кабинет
331	Кабинет 716	кабинет	7	Рабочий кабинет
332	Кабинет 717	кабинет	7	Рабочий кабинет
333	Кабинет 718	кабинет	7	Рабочий кабинет
334	Кабинет 719	кабинет	7	Рабочий кабинет
335	Кабинет 720	кабинет	7	Рабочий кабинет
336	Кабинет 799	кабинет	7	Рабочий кабинет
337	Кабинет 800	кабинет	8	Рабочий кабинет
338	Кабинет 801	кабинет	8	Рабочий кабинет
339	Кабинет 802	кабинет	8	Рабочий кабинет
340	Кабинет 803	кабинет	8	Рабочий кабинет
341	Кабинет 804	кабинет	8	Рабочий кабинет
342	Кабинет 805	кабинет	8	Рабочий кабинет
343	Кабинет 806	кабинет	8	Рабочий кабинет
344	Кабинет 807	кабинет	8	Рабочий кабинет
345	Кабинет 808	кабинет	8	Рабочий кабинет
346	Кабинет 809	кабинет	8	Рабочий кабинет
347	Кабинет 810	кабинет	8	Рабочий кабинет
348	Кабинет 811	кабинет	8	Рабочий кабинет
349	Кабинет 812	кабинет	8	Рабочий кабинет
350	Кабинет 813	кабинет	8	Рабочий кабинет
351	Кабинет 814	кабинет	8	Рабочий кабинет
352	Кабинет 815	кабинет	8	Рабочий кабинет
353	Кабинет 816	кабинет	8	Рабочий кабинет
354	Кабинет 817	кабинет	8	Рабочий кабинет
355	Кабинет 818	кабинет	8	Рабочий кабинет
356	Кабинет 819	кабинет	8	Рабочий кабинет
357	Кабинет 820	кабинет	8	Рабочий кабинет
358	Кабинет 899	кабинет	8	Рабочий кабинет
359	Склад А	склад	1	Склад техники
360	Склад Б	склад	1	Склад техники
361	Серверная 1	серверная	2	Серверная комната
362	Серверная 2	серверная	5	Серверная комната
363	Лаборатория 1	лаборатория	3	Испытательная лаборатория
364	Лаборатория 2	лаборатория	6	Испытательная лаборатория
\.


--
-- TOC entry 3723 (class 0 OID 91929)
-- Dependencies: 227
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migration (version, apply_time) FROM stdin;
m000000_000000_base	1761720389
\.


--
-- TOC entry 3724 (class 0 OID 91932)
-- Dependencies: 228
-- Data for Name: part_char_values; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.part_char_values (id_part_char, id_part, id_char, value_text, id_arm) FROM stdin;
1022	1	2	Intel	103
1023	1	1	I5-12500	103
1024	1	6	4.5	103
1025	1	54	8	103
1026	2	11	DDR4	103
1027	2	4	16	103
1028	2	55	3200	103
1029	3	5	1024	103
1030	3	12	SSD	103
1031	5	50	Цветной	103
1032	6	13	650	103
1033	3	12	NVMe	103
1034	3	5	1024	103
421	4	2	HP	103
422	4	2	Samsung	104
423	4	2	LG	105
424	4	2	Dell	106
425	4	2	HP	107
426	4	2	Samsung	108
427	4	2	LG	109
428	4	2	Dell	110
429	4	2	HP	111
430	4	2	Samsung	112
431	4	2	LG	113
432	4	2	Dell	114
433	4	2	HP	115
434	4	2	Samsung	116
435	4	2	LG	117
436	4	2	Dell	118
437	4	2	HP	119
438	4	2	Samsung	120
439	4	2	LG	121
440	4	2	Dell	122
441	4	2	HP	123
442	4	2	Samsung	124
443	4	2	LG	125
444	4	2	Dell	126
445	4	2	HP	127
446	4	2	Samsung	128
447	4	2	LG	129
448	4	2	Dell	130
449	4	2	HP	131
450	4	2	Samsung	132
451	4	2	LG	133
452	4	2	Dell	134
453	4	2	HP	135
454	4	2	Samsung	136
455	4	2	LG	137
456	4	2	Dell	138
457	4	2	HP	139
458	4	2	Samsung	140
459	4	2	LG	141
460	4	2	Dell	142
461	4	2	HP	143
462	4	2	Samsung	144
463	4	2	LG	145
464	4	2	Dell	146
465	4	2	HP	147
466	4	2	Samsung	148
467	4	2	LG	149
468	4	2	Dell	150
469	4	2	HP	151
470	4	2	Samsung	152
471	4	2	LG	153
472	4	2	Dell	154
473	4	2	HP	155
474	4	2	Samsung	156
475	4	2	LG	157
476	4	2	Dell	158
477	4	2	HP	159
478	4	2	Samsung	160
479	4	2	LG	161
480	4	2	Dell	162
481	4	2	HP	163
482	4	2	Samsung	164
483	4	2	LG	165
484	4	2	Dell	166
485	4	2	HP	167
486	4	2	Samsung	168
487	4	2	LG	169
488	4	2	Dell	170
489	4	2	HP	171
490	4	2	Samsung	172
491	4	2	LG	173
492	4	2	Dell	174
493	4	2	HP	175
494	4	2	Samsung	176
495	4	2	LG	177
496	4	2	Dell	178
497	4	2	HP	179
498	4	2	Samsung	180
499	4	2	LG	181
500	4	2	Dell	182
501	4	2	HP	183
502	4	2	Samsung	184
503	4	2	LG	185
504	4	2	Dell	186
505	4	2	HP	187
506	4	2	Samsung	188
507	4	2	LG	189
508	4	2	Dell	190
509	4	2	HP	191
510	4	2	Samsung	192
511	4	2	LG	193
512	4	2	Dell	194
513	4	2	HP	195
514	4	2	Samsung	196
515	4	2	LG	197
516	4	2	Dell	198
517	4	2	HP	199
518	4	2	Samsung	200
519	4	2	LG	201
520	4	2	Dell	202
521	4	1	MON-000103	103
522	4	1	MON-000104	104
523	4	1	MON-000105	105
524	4	1	MON-000106	106
525	4	1	MON-000107	107
526	4	1	MON-000108	108
527	4	1	MON-000109	109
528	4	1	MON-000110	110
529	4	1	MON-000111	111
530	4	1	MON-000112	112
531	4	1	MON-000113	113
532	4	1	MON-000114	114
533	4	1	MON-000115	115
534	4	1	MON-000116	116
535	4	1	MON-000117	117
536	4	1	MON-000118	118
537	4	1	MON-000119	119
538	4	1	MON-000120	120
539	4	1	MON-000121	121
540	4	1	MON-000122	122
541	4	1	MON-000123	123
542	4	1	MON-000124	124
543	4	1	MON-000125	125
544	4	1	MON-000126	126
545	4	1	MON-000127	127
546	4	1	MON-000128	128
547	4	1	MON-000129	129
548	4	1	MON-000130	130
549	4	1	MON-000131	131
550	4	1	MON-000132	132
551	4	1	MON-000133	133
552	4	1	MON-000134	134
553	4	1	MON-000135	135
554	4	1	MON-000136	136
555	4	1	MON-000137	137
556	4	1	MON-000138	138
557	4	1	MON-000139	139
558	4	1	MON-000140	140
559	4	1	MON-000141	141
560	4	1	MON-000142	142
561	4	1	MON-000143	143
562	4	1	MON-000144	144
563	4	1	MON-000145	145
564	4	1	MON-000146	146
565	4	1	MON-000147	147
566	4	1	MON-000148	148
567	4	1	MON-000149	149
568	4	1	MON-000150	150
569	4	1	MON-000151	151
570	4	1	MON-000152	152
571	4	1	MON-000153	153
572	4	1	MON-000154	154
573	4	1	MON-000155	155
574	4	1	MON-000156	156
575	4	1	MON-000157	157
576	4	1	MON-000158	158
577	4	1	MON-000159	159
578	4	1	MON-000160	160
579	4	1	MON-000161	161
580	4	1	MON-000162	162
581	4	1	MON-000163	163
582	4	1	MON-000164	164
583	4	1	MON-000165	165
584	4	1	MON-000166	166
585	4	1	MON-000167	167
586	4	1	MON-000168	168
587	4	1	MON-000169	169
588	4	1	MON-000170	170
589	4	1	MON-000171	171
590	4	1	MON-000172	172
591	4	1	MON-000173	173
592	4	1	MON-000174	174
593	4	1	MON-000175	175
594	4	1	MON-000176	176
595	4	1	MON-000177	177
596	4	1	MON-000178	178
597	4	1	MON-000179	179
598	4	1	MON-000180	180
599	4	1	MON-000181	181
600	4	1	MON-000182	182
601	4	1	MON-000183	183
602	4	1	MON-000184	184
603	4	1	MON-000185	185
604	4	1	MON-000186	186
605	4	1	MON-000187	187
606	4	1	MON-000188	188
607	4	1	MON-000189	189
608	4	1	MON-000190	190
609	4	1	MON-000191	191
610	4	1	MON-000192	192
611	4	1	MON-000193	193
612	4	1	MON-000194	194
613	4	1	MON-000195	195
614	4	1	MON-000196	196
615	4	1	MON-000197	197
616	4	1	MON-000198	198
617	4	1	MON-000199	199
618	4	1	MON-000200	200
619	4	1	MON-000201	201
620	4	1	MON-000202	202
621	4	3	24	103
622	4	3	27	104
623	4	3	21.5	105
624	4	3	24	106
625	4	3	27	107
626	4	3	21.5	108
627	4	3	24	109
628	4	3	27	110
629	4	3	21.5	111
630	4	3	24	112
631	4	3	27	113
632	4	3	21.5	114
633	4	3	24	115
634	4	3	27	116
635	4	3	21.5	117
636	4	3	24	118
637	4	3	27	119
638	4	3	21.5	120
639	4	3	24	121
640	4	3	27	122
641	4	3	21.5	123
642	4	3	24	124
643	4	3	27	125
644	4	3	21.5	126
645	4	3	24	127
646	4	3	27	128
647	4	3	21.5	129
648	4	3	24	130
649	4	3	27	131
650	4	3	21.5	132
651	4	3	24	133
652	4	3	27	134
653	4	3	21.5	135
654	4	3	24	136
655	4	3	27	137
656	4	3	21.5	138
657	4	3	24	139
658	4	3	27	140
659	4	3	21.5	141
660	4	3	24	142
661	4	3	27	143
662	4	3	21.5	144
663	4	3	24	145
664	4	3	27	146
665	4	3	21.5	147
666	4	3	24	148
667	4	3	27	149
668	4	3	21.5	150
669	4	3	24	151
670	4	3	27	152
671	4	3	21.5	153
672	4	3	24	154
673	4	3	27	155
674	4	3	21.5	156
675	4	3	24	157
676	4	3	27	158
677	4	3	21.5	159
678	4	3	24	160
679	4	3	27	161
680	4	3	21.5	162
681	4	3	24	163
682	4	3	27	164
683	4	3	21.5	165
684	4	3	24	166
685	4	3	27	167
686	4	3	21.5	168
687	4	3	24	169
688	4	3	27	170
689	4	3	21.5	171
690	4	3	24	172
691	4	3	27	173
692	4	3	21.5	174
693	4	3	24	175
694	4	3	27	176
695	4	3	21.5	177
696	4	3	24	178
697	4	3	27	179
698	4	3	21.5	180
699	4	3	24	181
700	4	3	27	182
701	4	3	21.5	183
702	4	3	24	184
703	4	3	27	185
704	4	3	21.5	186
705	4	3	24	187
706	4	3	27	188
707	4	3	21.5	189
708	4	3	24	190
709	4	3	27	191
710	4	3	21.5	192
711	4	3	24	193
712	4	3	27	194
713	4	3	21.5	195
714	4	3	24	196
715	4	3	27	197
716	4	3	21.5	198
717	4	3	24	199
718	4	3	27	200
719	4	3	21.5	201
720	4	3	24	202
721	4	10	2560x1440	103
722	4	10	1920x1080	104
723	4	10	2560x1440	105
724	4	10	1920x1080	106
725	4	10	2560x1440	107
726	4	10	1920x1080	108
727	4	10	2560x1440	109
728	4	10	1920x1080	110
729	4	10	2560x1440	111
730	4	10	1920x1080	112
731	4	10	2560x1440	113
732	4	10	1920x1080	114
733	4	10	2560x1440	115
734	4	10	1920x1080	116
735	4	10	2560x1440	117
736	4	10	1920x1080	118
737	4	10	2560x1440	119
738	4	10	1920x1080	120
739	4	10	2560x1440	121
740	4	10	1920x1080	122
741	4	10	2560x1440	123
742	4	10	1920x1080	124
743	4	10	2560x1440	125
744	4	10	1920x1080	126
745	4	10	2560x1440	127
746	4	10	1920x1080	128
747	4	10	2560x1440	129
748	4	10	1920x1080	130
749	4	10	2560x1440	131
750	4	10	1920x1080	132
751	4	10	2560x1440	133
752	4	10	1920x1080	134
753	4	10	2560x1440	135
754	4	10	1920x1080	136
755	4	10	2560x1440	137
756	4	10	1920x1080	138
757	4	10	2560x1440	139
758	4	10	1920x1080	140
759	4	10	2560x1440	141
760	4	10	1920x1080	142
761	4	10	2560x1440	143
762	4	10	1920x1080	144
763	4	10	2560x1440	145
764	4	10	1920x1080	146
765	4	10	2560x1440	147
766	4	10	1920x1080	148
767	4	10	2560x1440	149
768	4	10	1920x1080	150
769	4	10	2560x1440	151
770	4	10	1920x1080	152
771	4	10	2560x1440	153
772	4	10	1920x1080	154
773	4	10	2560x1440	155
774	4	10	1920x1080	156
775	4	10	2560x1440	157
776	4	10	1920x1080	158
777	4	10	2560x1440	159
778	4	10	1920x1080	160
779	4	10	2560x1440	161
780	4	10	1920x1080	162
781	4	10	2560x1440	163
782	4	10	1920x1080	164
783	4	10	2560x1440	165
784	4	10	1920x1080	166
785	4	10	2560x1440	167
786	4	10	1920x1080	168
787	4	10	2560x1440	169
788	4	10	1920x1080	170
789	4	10	2560x1440	171
790	4	10	1920x1080	172
791	4	10	2560x1440	173
792	4	10	1920x1080	174
793	4	10	2560x1440	175
794	4	10	1920x1080	176
795	4	10	2560x1440	177
796	4	10	1920x1080	178
797	4	10	2560x1440	179
798	4	10	1920x1080	180
799	4	10	2560x1440	181
800	4	10	1920x1080	182
801	4	10	2560x1440	183
802	4	10	1920x1080	184
803	4	10	2560x1440	185
804	4	10	1920x1080	186
805	4	10	2560x1440	187
806	4	10	1920x1080	188
807	4	10	2560x1440	189
808	4	10	1920x1080	190
809	4	10	2560x1440	191
810	4	10	1920x1080	192
811	4	10	2560x1440	193
812	4	10	1920x1080	194
813	4	10	2560x1440	195
814	4	10	1920x1080	196
815	4	10	2560x1440	197
816	4	10	1920x1080	198
817	4	10	2560x1440	199
818	4	10	1920x1080	200
819	4	10	2560x1440	201
820	4	10	1920x1080	202
821	5	2	Epson	104
822	5	2	Canon	106
823	5	2	HP	108
824	5	2	Epson	110
825	5	2	Canon	112
826	5	2	HP	114
827	5	2	Epson	116
828	5	2	Canon	118
829	5	2	HP	120
830	5	2	Epson	122
831	5	2	Canon	124
832	5	2	HP	126
833	5	2	Epson	128
834	5	2	Canon	130
835	5	2	HP	132
836	5	2	Epson	134
837	5	2	Canon	136
838	5	2	HP	138
839	5	2	Epson	140
840	5	2	Canon	142
841	5	2	HP	144
842	5	2	Epson	146
843	5	2	Canon	148
844	5	2	HP	150
845	5	2	Epson	152
846	5	2	Canon	154
847	5	2	HP	156
848	5	2	Epson	158
849	5	2	Canon	160
850	5	2	HP	162
851	5	2	Epson	164
852	5	2	Canon	166
853	5	2	HP	168
854	5	2	Epson	170
855	5	2	Canon	172
856	5	2	HP	174
857	5	2	Epson	176
858	5	2	Canon	178
859	5	2	HP	180
860	5	2	Epson	182
861	5	2	Canon	184
862	5	2	HP	186
863	5	2	Epson	188
864	5	2	Canon	190
865	5	2	HP	192
866	5	2	Epson	194
867	5	2	Canon	196
868	5	2	HP	198
869	5	2	Epson	200
870	5	2	Canon	202
871	5	1	PRN-000104	104
872	5	1	PRN-000106	106
873	5	1	PRN-000108	108
874	5	1	PRN-000110	110
875	5	1	PRN-000112	112
876	5	1	PRN-000114	114
877	5	1	PRN-000116	116
878	5	1	PRN-000118	118
879	5	1	PRN-000120	120
880	5	1	PRN-000122	122
881	5	1	PRN-000124	124
882	5	1	PRN-000126	126
883	5	1	PRN-000128	128
884	5	1	PRN-000130	130
885	5	1	PRN-000132	132
886	5	1	PRN-000134	134
887	5	1	PRN-000136	136
888	5	1	PRN-000138	138
889	5	1	PRN-000140	140
890	5	1	PRN-000142	142
891	5	1	PRN-000144	144
892	5	1	PRN-000146	146
893	5	1	PRN-000148	148
894	5	1	PRN-000150	150
895	5	1	PRN-000152	152
896	5	1	PRN-000154	154
897	5	1	PRN-000156	156
898	5	1	PRN-000158	158
899	5	1	PRN-000160	160
900	5	1	PRN-000162	162
901	5	1	PRN-000164	164
902	5	1	PRN-000166	166
903	5	1	PRN-000168	168
904	5	1	PRN-000170	170
905	5	1	PRN-000172	172
906	5	1	PRN-000174	174
907	5	1	PRN-000176	176
908	5	1	PRN-000178	178
909	5	1	PRN-000180	180
910	5	1	PRN-000182	182
911	5	1	PRN-000184	184
912	5	1	PRN-000186	186
913	5	1	PRN-000188	188
914	5	1	PRN-000190	190
915	5	1	PRN-000192	192
916	5	1	PRN-000194	194
917	5	1	PRN-000196	196
918	5	1	PRN-000198	198
919	5	1	PRN-000200	200
920	5	1	PRN-000202	202
921	5	49	лазерный	104
922	5	49	лазерный	106
923	5	49	лазерный	108
924	5	49	лазерный	110
925	5	49	лазерный	112
926	5	49	лазерный	114
927	5	49	лазерный	116
928	5	49	лазерный	118
929	5	49	лазерный	120
930	5	49	лазерный	122
931	5	49	лазерный	124
932	5	49	лазерный	126
933	5	49	лазерный	128
934	5	49	лазерный	130
935	5	49	лазерный	132
936	5	49	лазерный	134
937	5	49	лазерный	136
938	5	49	лазерный	138
939	5	49	лазерный	140
940	5	49	лазерный	142
941	5	49	лазерный	144
942	5	49	лазерный	146
943	5	49	лазерный	148
944	5	49	лазерный	150
945	5	49	лазерный	152
946	5	49	лазерный	154
947	5	49	лазерный	156
948	5	49	лазерный	158
949	5	49	лазерный	160
950	5	49	лазерный	162
951	5	49	лазерный	164
952	5	49	лазерный	166
953	5	49	лазерный	168
954	5	49	лазерный	170
955	5	49	лазерный	172
956	5	49	лазерный	174
957	5	49	лазерный	176
958	5	49	лазерный	178
959	5	49	лазерный	180
960	5	49	лазерный	182
961	5	49	лазерный	184
962	5	49	лазерный	186
963	5	49	лазерный	188
964	5	49	лазерный	190
965	5	49	лазерный	192
966	5	49	лазерный	194
967	5	49	лазерный	196
968	5	49	лазерный	198
969	5	49	лазерный	200
970	5	49	лазерный	202
971	5	50	черно-белый	104
972	5	50	черно-белый	106
973	5	50	черно-белый	108
974	5	50	черно-белый	110
975	5	50	черно-белый	112
976	5	50	черно-белый	114
977	5	50	черно-белый	116
978	5	50	черно-белый	118
979	5	50	черно-белый	120
980	5	50	черно-белый	122
981	5	50	черно-белый	124
982	5	50	черно-белый	126
983	5	50	черно-белый	128
984	5	50	черно-белый	130
985	5	50	черно-белый	132
986	5	50	черно-белый	134
987	5	50	черно-белый	136
988	5	50	черно-белый	138
989	5	50	черно-белый	140
990	5	50	черно-белый	142
991	5	50	черно-белый	144
992	5	50	черно-белый	146
993	5	50	черно-белый	148
994	5	50	черно-белый	150
995	5	50	черно-белый	152
996	5	50	черно-белый	154
997	5	50	черно-белый	156
998	5	50	черно-белый	158
999	5	50	черно-белый	160
1000	5	50	черно-белый	162
1001	5	50	черно-белый	164
1002	5	50	черно-белый	166
1003	5	50	черно-белый	168
1004	5	50	черно-белый	170
1005	5	50	черно-белый	172
1006	5	50	черно-белый	174
1007	5	50	черно-белый	176
1008	5	50	черно-белый	178
1009	5	50	черно-белый	180
1010	5	50	черно-белый	182
1011	5	50	черно-белый	184
1012	5	50	черно-белый	186
1013	5	50	черно-белый	188
1014	5	50	черно-белый	190
1015	5	50	черно-белый	192
1016	5	50	черно-белый	194
1017	5	50	черно-белый	196
1018	5	50	черно-белый	198
1019	5	50	черно-белый	200
1020	5	50	черно-белый	202
\.


--
-- TOC entry 3726 (class 0 OID 91938)
-- Dependencies: 230
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_role, role_name) FROM stdin;
4	пользователь
5	администратор
6	оператор
\.


--
-- TOC entry 3728 (class 0 OID 91944)
-- Dependencies: 232
-- Data for Name: spr_char; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spr_char (id_char, name, description, measurement_unit) FROM stdin;
1	Модель	Модель устройства	\N
2	Производитель	Производитель оборудования	\N
7	Серийный номер	Серийный номер устройства	\N
8	Инвентарный номер	Инвентарный номер	\N
9	Дата производства	Дата производства	\N
10	Разрешение	Разрешение экрана (например: 1920x1080)	\N
11	Тип памяти	Тип памяти (DDR3, DDR4, DDR5)	\N
12	Тип накопителя	Тип накопителя (HDD, SSD, NVMe)	\N
47	Тип матрицы	Тип матрицы монитора	\N
48	Яркость	Яркость монитора	\N
49	Тип принтера	Тип принтера (лазерный, струйный, МФУ)	\N
50	Цветность	Цветность принтера	\N
51	Производительность печати	Скорость печати	\N
52	Вместимость ИБП	Вместимость ИБП в ВА	\N
53	Время работы	Время автономной работы ИБП	\N
54	Количество ядер	\N	\N
3	Диагональ	Диагональ экрана	"
4	Объем памяти	Объем оперативной памяти	ГБ
5	Объем диска	Объем жесткого диска или SSD	ГБ
6	Частота процессора	Тактовая частота процессора	ГГц
55	Частота памяти	\N	МГц
13	Мощность	Потребляемая мощность	Вт
\.


--
-- TOC entry 3730 (class 0 OID 91950)
-- Dependencies: 234
-- Data for Name: spr_parts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spr_parts (id_part, name, description) FROM stdin;
1	Процессор	Центральный процессор (CPU)
2	Оперативная память	Модули оперативной памяти (RAM)
3	Жесткий диск	Накопитель данных (HDD/SSD)
4	Монитор	Монитор
5	Принтер	Принтер/МФУ
6	ИБП	Источник бесперебойного питания
7	Клавиатура	Клавиатура
8	Мышь	Компьютерная мышь
9	Материнская плата	Материнская плата
10	Видеокарта	Видеокарта
11	Блок питания	Блок питания
12	Сетевая карта	Сетевая карта
\.


--
-- TOC entry 3732 (class 0 OID 91957)
-- Dependencies: 236
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, id_status, description, id_user, date, last_time_update, comment, executor_id, attachments) FROM stdin;
2	1	Task2	407	2025-10-29 16:54:54.413968	2025-10-29 16:54:54.413968	\N	\N	[]
3	1	Task3	407	2025-10-29 16:55:08.97896	2025-10-29 16:55:08.97896	\N	\N	[]
4	1	Task4	407	2025-10-29 16:55:42.273064	2025-10-29 16:55:42.273064	\N	\N	[]
6	2	Task6	407	2025-10-29 18:04:09.383727	2025-10-31 19:13:28.758308	\N	\N	[4]
7	3	Task 22	409	2025-10-31 19:35:13.867387	2025-11-01 20:34:03.994666	\N	\N	[]
8	1	Задача 12	409	2025-11-01 21:11:58.177413	2025-11-01 21:11:58.177413	\N	\N	[]
10	1	123123123	409	2025-11-01 21:29:53.463585	2025-11-01 21:29:53.463585	\N	\N	[]
11	1	щотщж	409	2025-11-01 21:32:11.185228	2025-11-01 21:32:11.185228	\N	\N	[]
13	2	фывфывфывфывфывфвф	409	2025-11-01 21:34:18.773195	2025-11-01 22:06:43.333161	\N	\N	[]
12	3	12312312313131313123	409	2025-11-01 21:34:04.653041	2025-11-01 22:06:44.697347	\N	\N	[]
14	1	sa	409	2025-11-01 22:06:29.64968	2025-11-01 22:06:47.16684	\N	\N	[]
1	1	Task1	301	2025-10-29 15:05:44.332221	2025-11-01 22:17:01.242	\N	\N	[1]
16	6	3333333	409	2025-11-01 22:20:58.392628	2025-11-01 22:38:13.527336	Салам пополам не тупи перезагрузи комп	\N	[13,14]
9	1	123	409	2025-11-01 21:21:57.317135	2025-11-01 22:40:00.919855	asdasdasdasdasd	\N	[]
17	2	Заявка от Маховой. Не работает принтер. Срочно	401	2025-11-03 21:17:07.363793	2025-11-03 21:17:36.107509	СРОЧНО	301	[]
18	1	ppetrov1	404	2025-11-03 23:43:45.935609	2025-11-03 23:43:45.935609	\N	\N	[]
19	6	ppetrov1	412	2025-11-03 23:50:57.476922	2026-02-05 20:44:17.92378	\N	\N	[15,16]
15	3	123123123123123123	401	2025-11-01 22:19:34.381887	2026-02-05 20:46:20.219973	хуй	\N	[12]
\.


--
-- TOC entry 3734 (class 0 OID 91965)
-- Dependencies: 238
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, full_name, "position", department, email, phone, created_at, password, auth_key, access_token, password_reset_token, id_role) FROM stdin;
404	Кулаков Дмитрий Дмитриевич	\N	\N	dkulakov@vniicentr.ru	\N	2025-10-29 16:27:58.949052	e10adc3949ba59abbe56e057f20f883e	2-0UGLWqDteFsE2SVZ9K_M4j8QmR9f-X	\N	\N	5
409	Климов Алексей Сергеевич	\N	\N	aklimov@vniicentr.ru	\N	2025-10-29 16:43:26.883362	e10adc3949ba59abbe56e057f20f883e	SjfiAR6-GoqB4eeIIy5igCIeWZ0lyAFe	\N	\N	6
406	Горштейн Евгений Михайлович	\N	\N	egorshtein@vniicnetr.ru	\N	2025-10-29 16:34:52.875392	e10adc3949ba59abbe56e057f20f883e	L72c_sqsdIf42SQaIIim2wkwXRxxrHDh	\N	\N	5
410	Паршуткина Александра Николаевна	\N	\N	aparshutkina@vniicentr.ru	\N	2025-10-29 16:45:15.655793	e10adc3949ba59abbe56e057f20f883e	Gh2iRc507VPYGAVZvMTQPnjqZ305fv7w	\N	\N	6
301	Иванов Иван Иванович	Инженер	Отдел разработки	ivanov.ii@company.ru	+7(999)111-11-01	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
302	Петров Петр Петрович	Программист	Отдел разработки	petrov.pp@company.ru	+7(999)111-11-02	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
303	Сидоров Сидор Сидорович	Тестировщик	Отдел разработки	sidorov.ss@company.ru	+7(999)111-11-03	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
304	Козлова Анна Сергеевна	Дизайнер	Отдел маркетинга	kozlova.as@company.ru	+7(999)111-11-04	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
305	Смирнов Алексей Владимирович	Менеджер проектов	Отдел управления	smirnov.av@company.ru	+7(999)111-11-05	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
306	Волкова Елена Николаевна	Бухгалтер	Финансовый отдел	volkova.en@company.ru	+7(999)111-11-06	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
307	Новиков Дмитрий Алексеевич	Системный администратор	IT-отдел	novikov.da@company.ru	+7(999)111-11-07	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
308	Морозова Мария Павловна	Юрист	Юридический отдел	morozova.mp@company.ru	+7(999)111-11-08	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
309	Лебедев Сергей Михайлович	Инженер	Отдел разработки	lebedev.sm@company.ru	+7(999)111-11-09	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
310	Соколова Ольга Ивановна	Аналитик	Отдел аналитики	sokolova.oi@company.ru	+7(999)111-11-10	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
311	Павлов Андрей Викторович	Программист	Отдел разработки	pavlov.av@company.ru	+7(999)111-11-11	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
312	Васильева Татьяна Сергеевна	HR-менеджер	Отдел кадров	vasileva.ts@company.ru	+7(999)111-11-12	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
313	Семенов Игорь Петрович	Инженер	Отдел разработки	semenov.ip@company.ru	+7(999)111-11-13	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
314	Голубева Наталья Александровна	Маркетолог	Отдел маркетинга	golubeva.na@company.ru	+7(999)111-11-14	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
315	Виноградов Павел Дмитриевич	Программист	Отдел разработки	vinogradov.pd@company.ru	+7(999)111-11-15	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
316	Федорова Юлия Олеговна	Менеджер	Отдел продаж	fedorova.yo@company.ru	+7(999)111-11-16	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
317	Ильин Максим Сергеевич	Системный администратор	IT-отдел	ilin.ms@company.ru	+7(999)111-11-17	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
318	Михайлова Екатерина Владимировна	Дизайнер	Отдел маркетинга	mihailova.ev@company.ru	+7(999)111-11-18	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
319	Титов Роман Андреевич	Инженер	Отдел разработки	titov.ra@company.ru	+7(999)111-11-19	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
320	Белова Анна Дмитриевна	Бухгалтер	Финансовый отдел	belova.ad@company.ru	+7(999)111-11-20	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
321	Комаров Владимир Игоревич	Программист	Отдел разработки	komarov.vi@company.ru	+7(999)111-11-21	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
322	Орлова Светлана Петровна	Аналитик	Отдел аналитики	orlova.sp@company.ru	+7(999)111-11-22	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
323	Марков Станислав Николаевич	Менеджер проектов	Отдел управления	markov.sn@company.ru	+7(999)111-11-23	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
324	Захарова Валентина Алексеевна	Тестировщик	Отдел разработки	zaharova.va@company.ru	+7(999)111-11-24	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
325	Киселев Артем Максимович	Инженер	Отдел разработки	kiselev.am@company.ru	+7(999)111-11-25	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
326	Макарова Ирина Сергеевна	HR-менеджер	Отдел кадров	makarova.is@company.ru	+7(999)111-11-26	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
327	Борисов Константин Викторович	Программист	Отдел разработки	borisov.kv@company.ru	+7(999)111-11-27	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
328	Ларина Евгения Ивановна	Юрист	Юридический отдел	larina.ei@company.ru	+7(999)111-11-28	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
329	Степанов Григорий Павлович	Системный администратор	IT-отдел	stepanov.gp@company.ru	+7(999)111-11-29	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
330	Рыбакова Надежда Михайловна	Маркетолог	Отдел маркетинга	rybakova.nm@company.ru	+7(999)111-11-30	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
331	Григорьев Артур Александрович	Инженер	Отдел разработки	grigorev.aa@company.ru	+7(999)111-11-31	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
407	Азиев Казбек Русланович	\N	\N	kaziev@vniicentr.ru	\N	2025-10-29 16:38:03.42116	e10adc3949ba59abbe56e057f20f883e	DW26giwW_OIXItdJZo_WcOFO3z2Cf00V	\N	\N	4
332	Кудрявцева Лилия Олеговна	Дизайнер	Отдел маркетинга	kudryavceva.lo@company.ru	+7(999)111-11-32	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
333	Данилов Егор Романович	Программист	Отдел разработки	danilov.er@company.ru	+7(999)111-11-33	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
334	Жукова Марина Владимировна	Бухгалтер	Финансовый отдел	zhukova.mv@company.ru	+7(999)111-11-34	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
335	Фомин Илья Дмитриевич	Менеджер	Отдел продаж	fomin.id@company.ru	+7(999)111-11-35	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
336	Исаева Вероника Сергеевна	Аналитик	Отдел аналитики	isaeva.vs@company.ru	+7(999)111-11-36	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
337	Журавлев Виктор Андреевич	Инженер	Отдел разработки	zhuravlev.va@company.ru	+7(999)111-11-37	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
338	Тарасова Людмила Петровна	Тестировщик	Отдел разработки	tarasova.lp@company.ru	+7(999)111-11-38	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
339	Савельев Олег Николаевич	Системный администратор	IT-отдел	savelyev.on@company.ru	+7(999)111-11-39	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
340	Филиппова Тамара Алексеевна	HR-менеджер	Отдел кадров	filippova.ta@company.ru	+7(999)111-11-40	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
341	Баранов Денис Максимович	Программист	Отдел разработки	baranov.dm@company.ru	+7(999)111-11-41	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
342	Пономарева Алла Сергеевна	Маркетолог	Отдел маркетинга	ponomareva.as@company.ru	+7(999)111-11-42	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
343	Андреев Никита Викторович	Инженер	Отдел разработки	andreev.nv@company.ru	+7(999)111-11-43	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
344	Никитина Галина Ивановна	Юрист	Юридический отдел	nikitina.gi@company.ru	+7(999)111-11-44	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
345	Сорокин Ростислав Павлович	Менеджер проектов	Отдел управления	sorokin.rp@company.ru	+7(999)111-11-45	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
346	Сергеева Лариса Михайловна	Дизайнер	Отдел маркетинга	sergeeva.lm@company.ru	+7(999)111-11-46	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
347	Ткачев Эдуард Александрович	Программист	Отдел разработки	tkachev.ea@company.ru	+7(999)111-11-47	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
348	Карпова Римма Олеговна	Бухгалтер	Финансовый отдел	karpova.ro@company.ru	+7(999)111-11-48	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
349	Гусев Тимур Романович	Инженер	Отдел разработки	gusev.tr@company.ru	+7(999)111-11-49	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
350	Ефимова Зоя Владимировна	Аналитик	Отдел аналитики	efimova.zv@company.ru	+7(999)111-11-50	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
351	Кузьмин Ян Дмитриевич	Программист	Отдел разработки	kuzmin.yd@company.ru	+7(999)111-11-51	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
352	Зайцева Инна Сергеевна	Тестировщик	Отдел разработки	zayceva.is@company.ru	+7(999)111-11-52	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
353	Романов Валерий Андреевич	Системный администратор	IT-отдел	romanov.va@company.ru	+7(999)111-11-53	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
354	Логинова Нина Петровна	Менеджер	Отдел продаж	loginova.np@company.ru	+7(999)111-11-54	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
355	Власов Игорь Николаевич	Инженер	Отдел разработки	vlasov.in@company.ru	+7(999)111-11-55	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
356	Соловьева Эльвира Алексеевна	HR-менеджер	Отдел кадров	soloveva.ea@company.ru	+7(999)111-11-56	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
357	Егоров Руслан Максимович	Программист	Отдел разработки	egorov.rm@company.ru	+7(999)111-11-57	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
358	Петухова Валерия Сергеевна	Маркетолог	Отдел маркетинга	petuhova.vs@company.ru	+7(999)111-11-58	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
359	Медведев Иван Викторович	Инженер	Отдел разработки	medvedev.iv@company.ru	+7(999)111-11-59	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
360	Крылова Анжела Ивановна	Юрист	Юридический отдел	krylova.ai@company.ru	+7(999)111-11-60	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
361	Казаков Геннадий Павлович	Менеджер проектов	Отдел управления	kazakov.gp@company.ru	+7(999)111-11-61	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
362	Абрамова Любовь Михайловна	Дизайнер	Отдел маркетинга	abramova.lm@company.ru	+7(999)111-11-62	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
363	Орехов Олег Александрович	Программист	Отдел разработки	orehov.oa@company.ru	+7(999)111-11-63	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
364	Суворова Эмма Олеговна	Бухгалтер	Финансовый отдел	suvorova.eo@company.ru	+7(999)111-11-64	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
365	Трофимов Аркадий Романович	Инженер	Отдел разработки	trofimov.ar@company.ru	+7(999)111-11-65	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
366	Леонова Клавдия Владимировна	Аналитик	Отдел аналитики	leonova.kv@company.ru	+7(999)111-11-66	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
367	Бирюков Всеволод Дмитриевич	Программист	Отдел разработки	biryukov.vd@company.ru	+7(999)111-11-67	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
368	Котова Роза Сергеевна	Тестировщик	Отдел разработки	kotova.rs@company.ru	+7(999)111-11-68	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
369	Сидоренко Георгий Андреевич	Системный администратор	IT-отдел	sidorenko.ga@company.ru	+7(999)111-11-69	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
370	Мартынова Ксения Петровна	Менеджер	Отдел продаж	martynova.kp@company.ru	+7(999)111-11-70	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
371	Герасимов Анатолий Николаевич	Инженер	Отдел разработки	gerasimov.an@company.ru	+7(999)111-11-71	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
372	Мельникова Раиса Алексеевна	HR-менеджер	Отдел кадров	melnikova.ra@company.ru	+7(999)111-11-72	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
373	Панов Федор Максимович	Программист	Отдел разработки	panov.fm@company.ru	+7(999)111-11-73	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
374	Родионова Галина Сергеевна	Маркетолог	Отдел маркетинга	rodionova.gs@company.ru	+7(999)111-11-74	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
375	Филатов Юрий Викторович	Инженер	Отдел разработки	filatov.yv@company.ru	+7(999)111-11-75	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
376	Гончарова Наталья Ивановна	Юрист	Юридический отдел	goncharova.ni@company.ru	+7(999)111-11-76	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
377	Краснов Борис Павлович	Менеджер проектов	Отдел управления	krasnov.bp@company.ru	+7(999)111-11-77	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
378	Антонова Елена Михайловна	Дизайнер	Отдел маркетинга	antonova.em@company.ru	+7(999)111-11-78	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
379	Щербаков Вадим Александрович	Программист	Отдел разработки	scherbakov.va@company.ru	+7(999)111-11-79	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
380	Фролова Светлана Олеговна	Бухгалтер	Финансовый отдел	frolova.so@company.ru	+7(999)111-11-80	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
381	Шаров Сергей Романович	Инженер	Отдел разработки	sharov.sr@company.ru	+7(999)111-11-81	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
382	Горбачева Оксана Владимировна	Аналитик	Отдел аналитики	gorbacheva.ov@company.ru	+7(999)111-11-82	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
383	Блохин Дмитрий Дмитриевич	Программист	Отдел разработки	blohin.dd@company.ru	+7(999)111-11-83	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
384	Шилова Валентина Сергеевна	Тестировщик	Отдел разработки	shilova.vs@company.ru	+7(999)111-11-84	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
385	Беляков Владимир Андреевич	Системный администратор	IT-отдел	belyakov.va@company.ru	+7(999)111-11-85	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
386	Полякова Татьяна Петровна	Менеджер	Отдел продаж	polyakova.tp@company.ru	+7(999)111-11-86	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
387	Осипов Олег Николаевич	Инженер	Отдел разработки	osipov.on@company.ru	+7(999)111-11-87	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
388	Лаптева Лидия Алексеевна	HR-менеджер	Отдел кадров	lapteva.la@company.ru	+7(999)111-11-88	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
389	Мамонтов Илья Максимович	Программист	Отдел разработки	mamontov.im@company.ru	+7(999)111-11-89	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
390	Дорофеева Анастасия Сергеевна	Маркетолог	Отдел маркетинга	dorofeeva.as@company.ru	+7(999)111-11-90	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
391	Петровский Станислав Викторович	Инженер	Отдел разработки	petrovsky.sv@company.ru	+7(999)111-11-91	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
392	Козловская Вера Ивановна	Юрист	Юридический отдел	kozlovskaya.vi@company.ru	+7(999)111-11-92	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
393	Воробьев Эдуард Павлович	Менеджер проектов	Отдел управления	vorobev.ep@company.ru	+7(999)111-11-93	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
394	Федосеева Ирина Михайловна	Дизайнер	Отдел маркетинга	fedoseeva.im@company.ru	+7(999)111-11-94	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
395	Носов Антон Александрович	Программист	Отдел разработки	nosov.aa@company.ru	+7(999)111-11-95	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
396	Семенова Мария Олеговна	Бухгалтер	Финансовый отдел	semenova.mo@company.ru	+7(999)111-11-96	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
397	Горшков Николай Романович	Инженер	Отдел разработки	gorshkov.nr@company.ru	+7(999)111-11-97	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
398	Панова Елена Владимировна	Аналитик	Отдел аналитики	panova.ev@company.ru	+7(999)111-11-98	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
399	Голубев Роман Дмитриевич	Программист	Отдел разработки	golubev.rd@company.ru	+7(999)111-11-99	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
400	Иванова Тамара Сергеевна	Тестировщик	Отдел разработки	ivanova.ts@company.ru	+7(999)111-11-00	2025-10-27 11:40:00.596502	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	4
401	Ревва Рубен Рубенович	\N	\N	rrevva@vniicentr.ru	\N	2025-10-29 08:39:21.820563	e10adc3949ba59abbe56e057f20f883e	\N	\N	\N	5
411	Дятлов Дмитрий Александрович	\N	\N	ddyatlov@vniicentr.ru	\N	2025-10-29 16:46:25.45724	e10adc3949ba59abbe56e057f20f883e	iqvRRE9eQ3QZv29qZ8C4QxfKRKZH1ZEp	\N	\N	4
412	Петров Петр Петрович	\N	\N	ppetrov@vniicentr.ru	\N	2025-11-03 23:43:30.180994	e10adc3949ba59abbe56e057f20f883e	F20cbLXynkfVm6Abf5h8EicbW6ZXSS47	\N	\N	4
\.


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 219
-- Name: arm_history_id_history_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arm_history_id_history_seq', 1, false);


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 220
-- Name: arm_id_arm_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.arm_id_arm_seq', 204, true);


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 222
-- Name: desk_attachments_attach_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.desk_attachments_attach_id_seq', 16, true);


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 224
-- Name: dic_task_status_id_status_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dic_task_status_id_status_seq', 6, true);


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 226
-- Name: locations_id_location_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_location_seq', 364, true);


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 229
-- Name: part_char_values_id_part_char_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.part_char_values_id_part_char_seq', 1035, true);


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 231
-- Name: roles_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_role_seq', 6, true);


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 233
-- Name: spr_char_id_char_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.spr_char_id_char_seq', 55, true);


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 235
-- Name: spr_parts_id_part_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.spr_parts_id_part_seq', 36, true);


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 237
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 19, true);


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 239
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_user_seq', 412, true);


--
-- TOC entry 3529 (class 2606 OID 91987)
-- Name: arm_history arm_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm_history
    ADD CONSTRAINT arm_history_pkey PRIMARY KEY (id_history);


--
-- TOC entry 3527 (class 2606 OID 91989)
-- Name: arm arm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm
    ADD CONSTRAINT arm_pkey PRIMARY KEY (id_arm);


--
-- TOC entry 3531 (class 2606 OID 91991)
-- Name: desk_attachments desk_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desk_attachments
    ADD CONSTRAINT desk_attachments_pkey PRIMARY KEY (attach_id);


--
-- TOC entry 3534 (class 2606 OID 91993)
-- Name: dic_task_status dic_task_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dic_task_status
    ADD CONSTRAINT dic_task_status_pkey PRIMARY KEY (id_status);


--
-- TOC entry 3536 (class 2606 OID 91995)
-- Name: dic_task_status dic_task_status_status_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dic_task_status
    ADD CONSTRAINT dic_task_status_status_name_key UNIQUE (status_name);


--
-- TOC entry 3538 (class 2606 OID 91997)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id_location);


--
-- TOC entry 3542 (class 2606 OID 91999)
-- Name: migration migration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (version);


--
-- TOC entry 3544 (class 2606 OID 92001)
-- Name: part_char_values part_char_values_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.part_char_values
    ADD CONSTRAINT part_char_values_pkey PRIMARY KEY (id_part_char);


--
-- TOC entry 3546 (class 2606 OID 92003)
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id_role);


--
-- TOC entry 3548 (class 2606 OID 92005)
-- Name: spr_char spr_char_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spr_char
    ADD CONSTRAINT spr_char_name_key UNIQUE (name);


--
-- TOC entry 3550 (class 2606 OID 92007)
-- Name: spr_char spr_char_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spr_char
    ADD CONSTRAINT spr_char_pkey PRIMARY KEY (id_char);


--
-- TOC entry 3552 (class 2606 OID 92009)
-- Name: spr_parts spr_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spr_parts
    ADD CONSTRAINT spr_parts_pkey PRIMARY KEY (id_part);


--
-- TOC entry 3555 (class 2606 OID 92011)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 3540 (class 2606 OID 92013)
-- Name: locations uq_location_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT uq_location_name UNIQUE (name);


--
-- TOC entry 3557 (class 2606 OID 92015)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- TOC entry 3532 (class 1259 OID 92016)
-- Name: idx_desk_attachments_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_desk_attachments_name ON public.desk_attachments USING btree (name);


--
-- TOC entry 3553 (class 1259 OID 92017)
-- Name: idx_tasks_executor_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tasks_executor_id ON public.tasks USING btree (executor_id);


--
-- TOC entry 3560 (class 2606 OID 92018)
-- Name: arm_history arm_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm_history
    ADD CONSTRAINT arm_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES public.users(id_user) ON DELETE SET NULL;


--
-- TOC entry 3561 (class 2606 OID 92023)
-- Name: arm_history arm_history_id_arm_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm_history
    ADD CONSTRAINT arm_history_id_arm_fkey FOREIGN KEY (id_arm) REFERENCES public.arm(id_arm) ON DELETE CASCADE;


--
-- TOC entry 3558 (class 2606 OID 92028)
-- Name: arm arm_id_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm
    ADD CONSTRAINT arm_id_location_fkey FOREIGN KEY (id_location) REFERENCES public.locations(id_location) ON DELETE RESTRICT;


--
-- TOC entry 3559 (class 2606 OID 92033)
-- Name: arm arm_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arm
    ADD CONSTRAINT arm_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user) ON DELETE SET NULL;


--
-- TOC entry 3562 (class 2606 OID 92038)
-- Name: part_char_values part_char_values_arm_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.part_char_values
    ADD CONSTRAINT part_char_values_arm_fk FOREIGN KEY (id_arm) REFERENCES public.arm(id_arm);


--
-- TOC entry 3563 (class 2606 OID 92043)
-- Name: part_char_values part_char_values_id_arm_part_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.part_char_values
    ADD CONSTRAINT part_char_values_id_arm_part_fkey FOREIGN KEY (id_part) REFERENCES public.spr_parts(id_part) ON DELETE CASCADE;


--
-- TOC entry 3564 (class 2606 OID 92048)
-- Name: part_char_values part_char_values_id_char_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.part_char_values
    ADD CONSTRAINT part_char_values_id_char_fkey FOREIGN KEY (id_char) REFERENCES public.spr_char(id_char) ON DELETE CASCADE;


--
-- TOC entry 3565 (class 2606 OID 92053)
-- Name: tasks tasks_dic_task_status_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_dic_task_status_fk FOREIGN KEY (id_status) REFERENCES public.dic_task_status(id_status);


--
-- TOC entry 3566 (class 2606 OID 92058)
-- Name: tasks tasks_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_users_fk FOREIGN KEY (id_user) REFERENCES public.users(id_user);


--
-- TOC entry 3567 (class 2606 OID 92063)
-- Name: users users_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_roles_fk FOREIGN KEY (id_role) REFERENCES public.roles(id_role);


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-02-09 07:05:15 MSK

--
-- PostgreSQL database dump complete
--

\unrestrict 1CmpQHRBQt7Pw8hPBkQP0cbBm0HSjJioOKwNe3uCmXjU8LMuOPpr5m4hhcJePfx

