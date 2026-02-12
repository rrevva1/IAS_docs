--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.0

-- Started on 2026-02-12 12:03:45

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
-- TOC entry 6 (class 2615 OID 62468)
-- Name: tech_accounting; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tech_accounting;


ALTER SCHEMA tech_accounting OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 62470)
-- Name: prevent_update_delete(); Type: FUNCTION; Schema: tech_accounting; Owner: postgres
--

CREATE FUNCTION tech_accounting.prevent_update_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    RAISE EXCEPTION 'Изменение и удаление записей запрещено для таблицы %', TG_TABLE_NAME;
END;
$$;


ALTER FUNCTION tech_accounting.prevent_update_delete() OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 62469)
-- Name: set_updated_at(); Type: FUNCTION; Schema: tech_accounting; Owner: postgres
--

CREATE FUNCTION tech_accounting.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION tech_accounting.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 257 (class 1259 OID 62932)
-- Name: audit_events; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.audit_events (
    id bigint NOT NULL,
    event_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    actor_id bigint,
    action_type character varying(100) NOT NULL,
    object_type character varying(100) NOT NULL,
    object_id character varying(100) NOT NULL,
    result_status character varying(20) NOT NULL,
    source_ip inet,
    user_agent text,
    request_id character varying(64),
    correlation_id character varying(64),
    payload jsonb,
    error_message text,
    CONSTRAINT chk_audit_result_status CHECK (((result_status)::text = ANY ((ARRAY['success'::character varying, 'error'::character varying, 'denied'::character varying])::text[])))
);


ALTER TABLE tech_accounting.audit_events OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 62931)
-- Name: audit_events_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.audit_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.audit_events_id_seq OWNER TO postgres;

--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 256
-- Name: audit_events_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.audit_events_id_seq OWNED BY tech_accounting.audit_events.id;


--
-- TOC entry 253 (class 1259 OID 62881)
-- Name: desk_attachments; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.desk_attachments (
    id bigint NOT NULL,
    storage_path character varying(1000) NOT NULL,
    original_name character varying(255) NOT NULL,
    file_extension character varying(20),
    mime_type character varying(150),
    size_bytes bigint NOT NULL,
    checksum_sha256 character(64),
    uploaded_by bigint,
    uploaded_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_attachment_size_nonnegative CHECK ((size_bytes >= 0))
);


ALTER TABLE tech_accounting.desk_attachments OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 62880)
-- Name: desk_attachments_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.desk_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.desk_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 252
-- Name: desk_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.desk_attachments_id_seq OWNED BY tech_accounting.desk_attachments.id;


--
-- TOC entry 231 (class 1259 OID 62609)
-- Name: dic_equipment_status; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.dic_equipment_status (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(100) NOT NULL,
    sort_order integer DEFAULT 100 NOT NULL,
    is_final boolean DEFAULT false NOT NULL,
    is_archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.dic_equipment_status OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 62608)
-- Name: dic_equipment_status_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.dic_equipment_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.dic_equipment_status_id_seq OWNER TO postgres;

--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 230
-- Name: dic_equipment_status_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.dic_equipment_status_id_seq OWNED BY tech_accounting.dic_equipment_status.id;


--
-- TOC entry 233 (class 1259 OID 62625)
-- Name: dic_task_status; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.dic_task_status (
    id bigint NOT NULL,
    status_code character varying(50) NOT NULL,
    status_name character varying(100) NOT NULL,
    sort_order integer DEFAULT 100 NOT NULL,
    is_final boolean DEFAULT false NOT NULL,
    is_archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.dic_task_status OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 62624)
-- Name: dic_task_status_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.dic_task_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.dic_task_status_id_seq OWNER TO postgres;

--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 232
-- Name: dic_task_status_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.dic_task_status_id_seq OWNED BY tech_accounting.dic_task_status.id;


--
-- TOC entry 243 (class 1259 OID 62734)
-- Name: equip_history; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.equip_history (
    id bigint NOT NULL,
    equipment_id bigint NOT NULL,
    event_type character varying(50) NOT NULL,
    old_value jsonb,
    new_value jsonb,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comment text,
    CONSTRAINT chk_equip_history_event_type CHECK (((event_type)::text = ANY ((ARRAY['create'::character varying, 'update'::character varying, 'move'::character varying, 'assign'::character varying, 'unassign'::character varying, 'status_change'::character varying, 'maintenance'::character varying, 'writeoff'::character varying, 'archive'::character varying, 'restore'::character varying])::text[])))
);


ALTER TABLE tech_accounting.equip_history OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 62733)
-- Name: equip_history_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.equip_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.equip_history_id_seq OWNER TO postgres;

--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 242
-- Name: equip_history_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.equip_history_id_seq OWNED BY tech_accounting.equip_history.id;


--
-- TOC entry 241 (class 1259 OID 62687)
-- Name: equipment; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.equipment (
    id bigint NOT NULL,
    inventory_number character varying(100) NOT NULL,
    serial_number character varying(150),
    name character varying(200) NOT NULL,
    equipment_type character varying(100),
    status_id bigint NOT NULL,
    responsible_user_id bigint,
    location_id bigint NOT NULL,
    supplier character varying(200),
    purchase_date date,
    commissioning_date date,
    warranty_until date,
    description text,
    archived_at timestamp with time zone,
    archive_reason text,
    is_archived boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_equipment_name_not_empty CHECK ((length(TRIM(BOTH FROM name)) > 0)),
    CONSTRAINT chk_equipment_warranty_dates CHECK (((warranty_until IS NULL) OR (commissioning_date IS NULL) OR (warranty_until >= commissioning_date)))
);


ALTER TABLE tech_accounting.equipment OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 62686)
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.equipment_id_seq OWNER TO postgres;

--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 240
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.equipment_id_seq OWNED BY tech_accounting.equipment.id;


--
-- TOC entry 261 (class 1259 OID 62973)
-- Name: import_errors; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.import_errors (
    id bigint NOT NULL,
    import_run_id bigint NOT NULL,
    row_number integer,
    error_code character varying(50),
    error_message text NOT NULL,
    raw_payload jsonb,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.import_errors OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 62972)
-- Name: import_errors_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.import_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.import_errors_id_seq OWNER TO postgres;

--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 260
-- Name: import_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.import_errors_id_seq OWNED BY tech_accounting.import_errors.id;


--
-- TOC entry 259 (class 1259 OID 62952)
-- Name: import_runs; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.import_runs (
    id bigint NOT NULL,
    source_type character varying(30) NOT NULL,
    source_name character varying(255),
    started_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    finished_at timestamp with time zone,
    total_rows integer DEFAULT 0 NOT NULL,
    success_rows integer DEFAULT 0 NOT NULL,
    error_rows integer DEFAULT 0 NOT NULL,
    run_status character varying(20) DEFAULT 'running'::character varying NOT NULL,
    initiated_by bigint,
    details jsonb,
    CONSTRAINT chk_import_rows_nonnegative CHECK (((total_rows >= 0) AND (success_rows >= 0) AND (error_rows >= 0))),
    CONSTRAINT chk_import_run_status CHECK (((run_status)::text = ANY ((ARRAY['running'::character varying, 'success'::character varying, 'error'::character varying, 'partial'::character varying])::text[])))
);


ALTER TABLE tech_accounting.import_runs OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 62951)
-- Name: import_runs_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.import_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.import_runs_id_seq OWNER TO postgres;

--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 258
-- Name: import_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.import_runs_id_seq OWNED BY tech_accounting.import_runs.id;


--
-- TOC entry 229 (class 1259 OID 62583)
-- Name: locations; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.locations (
    id bigint NOT NULL,
    location_code character varying(50),
    name character varying(150) NOT NULL,
    location_type character varying(50) NOT NULL,
    floor integer,
    description text,
    is_archived boolean DEFAULT false NOT NULL,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_location_type CHECK (((location_type)::text = ANY ((ARRAY['кабинет'::character varying, 'склад'::character varying, 'серверная'::character varying, 'лаборатория'::character varying, 'другое'::character varying])::text[]))),
    CONSTRAINT chk_locations_name_not_empty CHECK ((length(TRIM(BOTH FROM name)) > 0))
);


ALTER TABLE tech_accounting.locations OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 62582)
-- Name: locations_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.locations_id_seq OWNER TO postgres;

--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 228
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.locations_id_seq OWNED BY tech_accounting.locations.id;


--
-- TOC entry 239 (class 1259 OID 62671)
-- Name: nsi_change_log; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.nsi_change_log (
    id bigint NOT NULL,
    dictionary_name character varying(100) NOT NULL,
    record_id bigint NOT NULL,
    operation_type character varying(20) NOT NULL,
    old_value jsonb,
    new_value jsonb,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_nsi_change_operation CHECK (((operation_type)::text = ANY ((ARRAY['insert'::character varying, 'update'::character varying, 'archive'::character varying, 'restore'::character varying, 'delete'::character varying])::text[])))
);


ALTER TABLE tech_accounting.nsi_change_log OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 62670)
-- Name: nsi_change_log_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.nsi_change_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.nsi_change_log_id_seq OWNER TO postgres;

--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 238
-- Name: nsi_change_log_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.nsi_change_log_id_seq OWNED BY tech_accounting.nsi_change_log.id;


--
-- TOC entry 245 (class 1259 OID 62756)
-- Name: part_char_values; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.part_char_values (
    id bigint NOT NULL,
    equipment_id bigint NOT NULL,
    part_id bigint NOT NULL,
    char_id bigint NOT NULL,
    value_text text,
    value_num numeric(18,4),
    source character varying(50) DEFAULT 'manual'::character varying,
    updated_by bigint,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.part_char_values OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 62755)
-- Name: part_char_values_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.part_char_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.part_char_values_id_seq OWNER TO postgres;

--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 244
-- Name: part_char_values_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.part_char_values_id_seq OWNED BY tech_accounting.part_char_values.id;


--
-- TOC entry 221 (class 1259 OID 62489)
-- Name: permissions; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.permissions (
    id bigint NOT NULL,
    perm_code character varying(100) NOT NULL,
    perm_name character varying(200) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_permissions_perm_code_not_empty CHECK ((length(TRIM(BOTH FROM perm_code)) > 0)),
    CONSTRAINT chk_permissions_perm_name_not_empty CHECK ((length(TRIM(BOTH FROM perm_name)) > 0))
);


ALTER TABLE tech_accounting.permissions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 62488)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 220
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.permissions_id_seq OWNED BY tech_accounting.permissions.id;


--
-- TOC entry 227 (class 1259 OID 62558)
-- Name: role_permissions; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.role_permissions (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    granted_by bigint,
    granted_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.role_permissions OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 62557)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.role_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 226
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.role_permissions_id_seq OWNED BY tech_accounting.role_permissions.id;


--
-- TOC entry 219 (class 1259 OID 62472)
-- Name: roles; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.roles (
    id bigint NOT NULL,
    role_code character varying(50) NOT NULL,
    role_name character varying(150) NOT NULL,
    description text,
    is_system boolean DEFAULT false NOT NULL,
    is_archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_roles_role_code_not_empty CHECK ((length(TRIM(BOTH FROM role_code)) > 0)),
    CONSTRAINT chk_roles_role_name_not_empty CHECK ((length(TRIM(BOTH FROM role_name)) > 0))
);


ALTER TABLE tech_accounting.roles OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 62471)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.roles_id_seq OWNER TO postgres;

--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 218
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.roles_id_seq OWNED BY tech_accounting.roles.id;


--
-- TOC entry 237 (class 1259 OID 62656)
-- Name: spr_chars; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.spr_chars (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    measurement_unit character varying(50),
    is_archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_spr_chars_name_not_empty CHECK ((length(TRIM(BOTH FROM name)) > 0))
);


ALTER TABLE tech_accounting.spr_chars OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 62655)
-- Name: spr_chars_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.spr_chars_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.spr_chars_id_seq OWNER TO postgres;

--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 236
-- Name: spr_chars_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.spr_chars_id_seq OWNED BY tech_accounting.spr_chars.id;


--
-- TOC entry 235 (class 1259 OID 62641)
-- Name: spr_parts; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.spr_parts (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_archived boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_spr_parts_name_not_empty CHECK ((length(TRIM(BOTH FROM name)) > 0))
);


ALTER TABLE tech_accounting.spr_parts OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 62640)
-- Name: spr_parts_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.spr_parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.spr_parts_id_seq OWNER TO postgres;

--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 234
-- Name: spr_parts_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.spr_parts_id_seq OWNED BY tech_accounting.spr_parts.id;


--
-- TOC entry 255 (class 1259 OID 62905)
-- Name: task_attachments; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.task_attachments (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    attachment_id bigint NOT NULL,
    linked_by bigint,
    linked_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE tech_accounting.task_attachments OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 62904)
-- Name: task_attachments_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.task_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.task_attachments_id_seq OWNER TO postgres;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 254
-- Name: task_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.task_attachments_id_seq OWNED BY tech_accounting.task_attachments.id;


--
-- TOC entry 251 (class 1259 OID 62851)
-- Name: task_equipment; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.task_equipment (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    equipment_id bigint NOT NULL,
    relation_type character varying(30) DEFAULT 'related'::character varying NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    linked_by bigint,
    linked_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_task_equipment_relation_type CHECK (((relation_type)::text = ANY ((ARRAY['related'::character varying, 'affected'::character varying, 'requested_for'::character varying])::text[])))
);


ALTER TABLE tech_accounting.task_equipment OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 62850)
-- Name: task_equipment_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.task_equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.task_equipment_id_seq OWNER TO postgres;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 250
-- Name: task_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.task_equipment_id_seq OWNED BY tech_accounting.task_equipment.id;


--
-- TOC entry 249 (class 1259 OID 62830)
-- Name: task_history; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.task_history (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    field_name character varying(100) NOT NULL,
    old_value text,
    new_value text,
    changed_by bigint,
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    comment text
);


ALTER TABLE tech_accounting.task_history OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 62829)
-- Name: task_history_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.task_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.task_history_id_seq OWNER TO postgres;

--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 248
-- Name: task_history_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.task_history_id_seq OWNED BY tech_accounting.task_history.id;


--
-- TOC entry 247 (class 1259 OID 62791)
-- Name: tasks; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.tasks (
    id bigint NOT NULL,
    task_number character varying(50),
    title character varying(250),
    description text NOT NULL,
    status_id bigint NOT NULL,
    requester_id bigint NOT NULL,
    executor_id bigint,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    due_at timestamp with time zone,
    closed_at timestamp with time zone,
    comment text,
    attachments_legacy jsonb,
    is_deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    delete_reason text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_tasks_priority CHECK (((priority)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE tech_accounting.tasks OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 62790)
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.tasks_id_seq OWNER TO postgres;

--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 246
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.tasks_id_seq OWNED BY tech_accounting.tasks.id;


--
-- TOC entry 225 (class 1259 OID 62532)
-- Name: user_roles; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.user_roles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_by bigint,
    assigned_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    revoked_at timestamp with time zone,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE tech_accounting.user_roles OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 62531)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.user_roles_id_seq OWNER TO postgres;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 224
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.user_roles_id_seq OWNED BY tech_accounting.user_roles.id;


--
-- TOC entry 223 (class 1259 OID 62503)
-- Name: users; Type: TABLE; Schema: tech_accounting; Owner: postgres
--

CREATE TABLE tech_accounting.users (
    id bigint NOT NULL,
    username character varying(100),
    full_name character varying(200) NOT NULL,
    "position" character varying(100),
    department character varying(100),
    email character varying(150),
    phone character varying(50),
    password_hash character varying(255),
    is_active boolean DEFAULT true NOT NULL,
    is_locked boolean DEFAULT false NOT NULL,
    failed_login_attempts integer DEFAULT 0 NOT NULL,
    lock_until timestamp with time zone,
    password_changed_at timestamp with time zone,
    last_login_at timestamp with time zone,
    created_by_id bigint,
    updated_by_id bigint,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_users_failed_login_attempts_nonnegative CHECK ((failed_login_attempts >= 0)),
    CONSTRAINT chk_users_full_name_not_empty CHECK ((length(TRIM(BOTH FROM full_name)) > 0))
);


ALTER TABLE tech_accounting.users OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 62502)
-- Name: users_id_seq; Type: SEQUENCE; Schema: tech_accounting; Owner: postgres
--

CREATE SEQUENCE tech_accounting.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE tech_accounting.users_id_seq OWNER TO postgres;

--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: tech_accounting; Owner: postgres
--

ALTER SEQUENCE tech_accounting.users_id_seq OWNED BY tech_accounting.users.id;


--
-- TOC entry 4874 (class 2604 OID 62935)
-- Name: audit_events id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.audit_events ALTER COLUMN id SET DEFAULT nextval('tech_accounting.audit_events_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 62884)
-- Name: desk_attachments id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.desk_attachments ALTER COLUMN id SET DEFAULT nextval('tech_accounting.desk_attachments_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 62612)
-- Name: dic_equipment_status id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_equipment_status ALTER COLUMN id SET DEFAULT nextval('tech_accounting.dic_equipment_status_id_seq'::regclass);


--
-- TOC entry 4832 (class 2604 OID 62628)
-- Name: dic_task_status id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_task_status ALTER COLUMN id SET DEFAULT nextval('tech_accounting.dic_task_status_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 62737)
-- Name: equip_history id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equip_history ALTER COLUMN id SET DEFAULT nextval('tech_accounting.equip_history_id_seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 62690)
-- Name: equipment id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment ALTER COLUMN id SET DEFAULT nextval('tech_accounting.equipment_id_seq'::regclass);


--
-- TOC entry 4882 (class 2604 OID 62976)
-- Name: import_errors id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_errors ALTER COLUMN id SET DEFAULT nextval('tech_accounting.import_errors_id_seq'::regclass);


--
-- TOC entry 4876 (class 2604 OID 62955)
-- Name: import_runs id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_runs ALTER COLUMN id SET DEFAULT nextval('tech_accounting.import_runs_id_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 62586)
-- Name: locations id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.locations ALTER COLUMN id SET DEFAULT nextval('tech_accounting.locations_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 62674)
-- Name: nsi_change_log id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.nsi_change_log ALTER COLUMN id SET DEFAULT nextval('tech_accounting.nsi_change_log_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 62759)
-- Name: part_char_values id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values ALTER COLUMN id SET DEFAULT nextval('tech_accounting.part_char_values_id_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 62492)
-- Name: permissions id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.permissions ALTER COLUMN id SET DEFAULT nextval('tech_accounting.permissions_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 62561)
-- Name: role_permissions id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions ALTER COLUMN id SET DEFAULT nextval('tech_accounting.role_permissions_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 62475)
-- Name: roles id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.roles ALTER COLUMN id SET DEFAULT nextval('tech_accounting.roles_id_seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 62659)
-- Name: spr_chars id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_chars ALTER COLUMN id SET DEFAULT nextval('tech_accounting.spr_chars_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 62644)
-- Name: spr_parts id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_parts ALTER COLUMN id SET DEFAULT nextval('tech_accounting.spr_parts_id_seq'::regclass);


--
-- TOC entry 4872 (class 2604 OID 62908)
-- Name: task_attachments id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments ALTER COLUMN id SET DEFAULT nextval('tech_accounting.task_attachments_id_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 62854)
-- Name: task_equipment id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment ALTER COLUMN id SET DEFAULT nextval('tech_accounting.task_equipment_id_seq'::regclass);


--
-- TOC entry 4863 (class 2604 OID 62833)
-- Name: task_history id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_history ALTER COLUMN id SET DEFAULT nextval('tech_accounting.task_history_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 62794)
-- Name: tasks id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks ALTER COLUMN id SET DEFAULT nextval('tech_accounting.tasks_id_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 62535)
-- Name: user_roles id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles ALTER COLUMN id SET DEFAULT nextval('tech_accounting.user_roles_id_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 62506)
-- Name: users id; Type: DEFAULT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.users ALTER COLUMN id SET DEFAULT nextval('tech_accounting.users_id_seq'::regclass);


--
-- TOC entry 5238 (class 0 OID 62932)
-- Dependencies: 257
-- Data for Name: audit_events; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.audit_events (id, event_time, actor_id, action_type, object_type, object_id, result_status, source_ip, user_agent, request_id, correlation_id, payload, error_message) FROM stdin;
\.


--
-- TOC entry 5234 (class 0 OID 62881)
-- Dependencies: 253
-- Data for Name: desk_attachments; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.desk_attachments (id, storage_path, original_name, file_extension, mime_type, size_bytes, checksum_sha256, uploaded_by, uploaded_at, is_deleted, deleted_at, deleted_by) FROM stdin;
\.


--
-- TOC entry 5212 (class 0 OID 62609)
-- Dependencies: 231
-- Data for Name: dic_equipment_status; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.dic_equipment_status (id, status_code, status_name, sort_order, is_final, is_archived, created_at, updated_at) FROM stdin;
1	in_use	В эксплуатации	10	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
2	in_stock	На складе	20	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
3	in_repair	В ремонте	30	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
4	writeoff	Списано	40	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
5	archived	В архиве	50	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
\.


--
-- TOC entry 5214 (class 0 OID 62625)
-- Dependencies: 233
-- Data for Name: dic_task_status; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.dic_task_status (id, status_code, status_name, sort_order, is_final, is_archived, created_at, updated_at) FROM stdin;
1	new	Новая	10	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
2	in_progress	В работе	20	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
3	on_hold	На паузе	30	f	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
4	resolved	Решена	40	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
5	closed	Закрыта	50	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
6	cancelled	Отменена	60	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
\.


--
-- TOC entry 5224 (class 0 OID 62734)
-- Dependencies: 243
-- Data for Name: equip_history; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.equip_history (id, equipment_id, event_type, old_value, new_value, changed_by, changed_at, comment) FROM stdin;
\.


--
-- TOC entry 5222 (class 0 OID 62687)
-- Dependencies: 241
-- Data for Name: equipment; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.equipment (id, inventory_number, serial_number, name, equipment_type, status_id, responsible_user_id, location_id, supplier, purchase_date, commissioning_date, warranty_until, description, archived_at, archive_reason, is_archived, is_deleted, created_by_id, updated_by_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5242 (class 0 OID 62973)
-- Dependencies: 261
-- Data for Name: import_errors; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.import_errors (id, import_run_id, row_number, error_code, error_message, raw_payload, created_at) FROM stdin;
\.


--
-- TOC entry 5240 (class 0 OID 62952)
-- Dependencies: 259
-- Data for Name: import_runs; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.import_runs (id, source_type, source_name, started_at, finished_at, total_rows, success_rows, error_rows, run_status, initiated_by, details) FROM stdin;
\.


--
-- TOC entry 5210 (class 0 OID 62583)
-- Dependencies: 229
-- Data for Name: locations; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.locations (id, location_code, name, location_type, floor, description, is_archived, created_by_id, updated_by_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5220 (class 0 OID 62671)
-- Dependencies: 239
-- Data for Name: nsi_change_log; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.nsi_change_log (id, dictionary_name, record_id, operation_type, old_value, new_value, changed_by, changed_at) FROM stdin;
\.


--
-- TOC entry 5226 (class 0 OID 62756)
-- Dependencies: 245
-- Data for Name: part_char_values; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.part_char_values (id, equipment_id, part_id, char_id, value_text, value_num, source, updated_by, updated_at) FROM stdin;
\.


--
-- TOC entry 5202 (class 0 OID 62489)
-- Dependencies: 221
-- Data for Name: permissions; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.permissions (id, perm_code, perm_name, description, created_at) FROM stdin;
\.


--
-- TOC entry 5208 (class 0 OID 62558)
-- Dependencies: 227
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.role_permissions (id, role_id, permission_id, granted_by, granted_at) FROM stdin;
\.


--
-- TOC entry 5200 (class 0 OID 62472)
-- Dependencies: 219
-- Data for Name: roles; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.roles (id, role_code, role_name, description, is_system, is_archived, created_at, updated_at) FROM stdin;
1	admin	Администратор	Полный доступ к данным и настройкам	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
2	operator	Оператор	Обработка и сопровождение заявок	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
3	user	Пользователь	Создание и просмотр собственных заявок	t	f	2026-02-12 11:12:45.835301+03	2026-02-12 11:12:45.835301+03
\.


--
-- TOC entry 5218 (class 0 OID 62656)
-- Dependencies: 237
-- Data for Name: spr_chars; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.spr_chars (id, name, description, measurement_unit, is_archived, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5216 (class 0 OID 62641)
-- Dependencies: 235
-- Data for Name: spr_parts; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.spr_parts (id, name, description, is_archived, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5236 (class 0 OID 62905)
-- Dependencies: 255
-- Data for Name: task_attachments; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.task_attachments (id, task_id, attachment_id, linked_by, linked_at) FROM stdin;
\.


--
-- TOC entry 5232 (class 0 OID 62851)
-- Dependencies: 251
-- Data for Name: task_equipment; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.task_equipment (id, task_id, equipment_id, relation_type, is_primary, linked_by, linked_at) FROM stdin;
\.


--
-- TOC entry 5230 (class 0 OID 62830)
-- Dependencies: 249
-- Data for Name: task_history; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.task_history (id, task_id, field_name, old_value, new_value, changed_by, changed_at, comment) FROM stdin;
\.


--
-- TOC entry 5228 (class 0 OID 62791)
-- Dependencies: 247
-- Data for Name: tasks; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.tasks (id, task_number, title, description, status_id, requester_id, executor_id, priority, due_at, closed_at, comment, attachments_legacy, is_deleted, deleted_at, deleted_by, delete_reason, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 5206 (class 0 OID 62532)
-- Dependencies: 225
-- Data for Name: user_roles; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.user_roles (id, user_id, role_id, assigned_by, assigned_at, revoked_at, is_active) FROM stdin;
1	1	1	\N	2026-02-12 09:34:07+03	\N	t
\.


--
-- TOC entry 5204 (class 0 OID 62503)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: tech_accounting; Owner: postgres
--

COPY tech_accounting.users (id, username, full_name, "position", department, email, phone, password_hash, is_active, is_locked, failed_login_attempts, lock_until, password_changed_at, last_login_at, created_by_id, updated_by_id, created_at, updated_at, is_deleted) FROM stdin;
1	admin	Администратор	\N	\N	admin@local	\N	$2y$13$y6s1IyitMYGUXmB8oaNdPeup3dEk0vR1njJYND5zr74GjY10Xv3la	t	f	0	\N	\N	\N	\N	\N	2026-02-12 11:34:07.204663+03	2026-02-12 11:34:07.204663+03	f
\.


--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 256
-- Name: audit_events_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.audit_events_id_seq', 1, false);


--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 252
-- Name: desk_attachments_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.desk_attachments_id_seq', 1, false);


--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 230
-- Name: dic_equipment_status_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.dic_equipment_status_id_seq', 5, true);


--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 232
-- Name: dic_task_status_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.dic_task_status_id_seq', 6, true);


--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 242
-- Name: equip_history_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.equip_history_id_seq', 1, false);


--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 240
-- Name: equipment_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.equipment_id_seq', 1, false);


--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 260
-- Name: import_errors_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.import_errors_id_seq', 1, false);


--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 258
-- Name: import_runs_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.import_runs_id_seq', 1, false);


--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 228
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.locations_id_seq', 1, false);


--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 238
-- Name: nsi_change_log_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.nsi_change_log_id_seq', 1, false);


--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 244
-- Name: part_char_values_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.part_char_values_id_seq', 1, false);


--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 220
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.permissions_id_seq', 1, false);


--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 226
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.role_permissions_id_seq', 1, false);


--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 218
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.roles_id_seq', 3, true);


--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 236
-- Name: spr_chars_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.spr_chars_id_seq', 1, false);


--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 234
-- Name: spr_parts_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.spr_parts_id_seq', 1, false);


--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 254
-- Name: task_attachments_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.task_attachments_id_seq', 1, false);


--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 250
-- Name: task_equipment_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.task_equipment_id_seq', 1, false);


--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 248
-- Name: task_history_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.task_history_id_seq', 1, false);


--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 246
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.tasks_id_seq', 1, false);


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 224
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.user_roles_id_seq', 1, true);


--
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: tech_accounting; Owner: postgres
--

SELECT pg_catalog.setval('tech_accounting.users_id_seq', 1, true);


--
-- TOC entry 4995 (class 2606 OID 62941)
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4985 (class 2606 OID 62891)
-- Name: desk_attachments desk_attachments_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.desk_attachments
    ADD CONSTRAINT desk_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4929 (class 2606 OID 62619)
-- Name: dic_equipment_status dic_equipment_status_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_equipment_status
    ADD CONSTRAINT dic_equipment_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 62621)
-- Name: dic_equipment_status dic_equipment_status_status_code_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_equipment_status
    ADD CONSTRAINT dic_equipment_status_status_code_key UNIQUE (status_code);


--
-- TOC entry 4933 (class 2606 OID 62623)
-- Name: dic_equipment_status dic_equipment_status_status_name_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_equipment_status
    ADD CONSTRAINT dic_equipment_status_status_name_key UNIQUE (status_name);


--
-- TOC entry 4935 (class 2606 OID 62635)
-- Name: dic_task_status dic_task_status_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_task_status
    ADD CONSTRAINT dic_task_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4937 (class 2606 OID 62637)
-- Name: dic_task_status dic_task_status_status_code_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_task_status
    ADD CONSTRAINT dic_task_status_status_code_key UNIQUE (status_code);


--
-- TOC entry 4939 (class 2606 OID 62639)
-- Name: dic_task_status dic_task_status_status_name_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.dic_task_status
    ADD CONSTRAINT dic_task_status_status_name_key UNIQUE (status_name);


--
-- TOC entry 4960 (class 2606 OID 62743)
-- Name: equip_history equip_history_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equip_history
    ADD CONSTRAINT equip_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4951 (class 2606 OID 62700)
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- TOC entry 5004 (class 2606 OID 62981)
-- Name: import_errors import_errors_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_errors
    ADD CONSTRAINT import_errors_pkey PRIMARY KEY (id);


--
-- TOC entry 5001 (class 2606 OID 62966)
-- Name: import_runs import_runs_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_runs
    ADD CONSTRAINT import_runs_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 2606 OID 62597)
-- Name: locations locations_name_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.locations
    ADD CONSTRAINT locations_name_key UNIQUE (name);


--
-- TOC entry 4927 (class 2606 OID 62595)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- TOC entry 4949 (class 2606 OID 62680)
-- Name: nsi_change_log nsi_change_log_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.nsi_change_log
    ADD CONSTRAINT nsi_change_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4965 (class 2606 OID 62767)
-- Name: part_char_values part_char_values_equipment_id_part_id_char_id_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_equipment_id_part_id_char_id_key UNIQUE (equipment_id, part_id, char_id);


--
-- TOC entry 4967 (class 2606 OID 62765)
-- Name: part_char_values part_char_values_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 62501)
-- Name: permissions permissions_perm_code_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.permissions
    ADD CONSTRAINT permissions_perm_code_key UNIQUE (perm_code);


--
-- TOC entry 4911 (class 2606 OID 62499)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4921 (class 2606 OID 62564)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4923 (class 2606 OID 62566)
-- Name: role_permissions role_permissions_role_id_permission_id_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions
    ADD CONSTRAINT role_permissions_role_id_permission_id_key UNIQUE (role_id, permission_id);


--
-- TOC entry 4905 (class 2606 OID 62485)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 62487)
-- Name: roles roles_role_code_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.roles
    ADD CONSTRAINT roles_role_code_key UNIQUE (role_code);


--
-- TOC entry 4945 (class 2606 OID 62669)
-- Name: spr_chars spr_chars_name_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_chars
    ADD CONSTRAINT spr_chars_name_key UNIQUE (name);


--
-- TOC entry 4947 (class 2606 OID 62667)
-- Name: spr_chars spr_chars_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_chars
    ADD CONSTRAINT spr_chars_pkey PRIMARY KEY (id);


--
-- TOC entry 4941 (class 2606 OID 62654)
-- Name: spr_parts spr_parts_name_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_parts
    ADD CONSTRAINT spr_parts_name_key UNIQUE (name);


--
-- TOC entry 4943 (class 2606 OID 62652)
-- Name: spr_parts spr_parts_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.spr_parts
    ADD CONSTRAINT spr_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4991 (class 2606 OID 62911)
-- Name: task_attachments task_attachments_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments
    ADD CONSTRAINT task_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4993 (class 2606 OID 62913)
-- Name: task_attachments task_attachments_task_id_attachment_id_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments
    ADD CONSTRAINT task_attachments_task_id_attachment_id_key UNIQUE (task_id, attachment_id);


--
-- TOC entry 4981 (class 2606 OID 62860)
-- Name: task_equipment task_equipment_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment
    ADD CONSTRAINT task_equipment_pkey PRIMARY KEY (id);


--
-- TOC entry 4983 (class 2606 OID 62862)
-- Name: task_equipment task_equipment_task_id_equipment_id_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment
    ADD CONSTRAINT task_equipment_task_id_equipment_id_key UNIQUE (task_id, equipment_id);


--
-- TOC entry 4977 (class 2606 OID 62838)
-- Name: task_history task_history_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 62803)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4974 (class 2606 OID 62805)
-- Name: tasks tasks_task_number_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_task_number_key UNIQUE (task_number);


--
-- TOC entry 4957 (class 2606 OID 62702)
-- Name: equipment uq_equipment_inventory_number; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT uq_equipment_inventory_number UNIQUE (inventory_number);


--
-- TOC entry 4917 (class 2606 OID 62539)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4919 (class 2606 OID 62541)
-- Name: user_roles user_roles_user_id_role_id_is_active_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles
    ADD CONSTRAINT user_roles_user_id_role_id_is_active_key UNIQUE (user_id, role_id, is_active);


--
-- TOC entry 4913 (class 2606 OID 62518)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4915 (class 2606 OID 62520)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4996 (class 1259 OID 62950)
-- Name: idx_audit_events_action; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_audit_events_action ON tech_accounting.audit_events USING btree (action_type, result_status);


--
-- TOC entry 4997 (class 1259 OID 62948)
-- Name: idx_audit_events_actor_time; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_audit_events_actor_time ON tech_accounting.audit_events USING btree (actor_id, event_time DESC);


--
-- TOC entry 4998 (class 1259 OID 62947)
-- Name: idx_audit_events_event_time; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_audit_events_event_time ON tech_accounting.audit_events USING btree (event_time DESC);


--
-- TOC entry 4999 (class 1259 OID 62949)
-- Name: idx_audit_events_object; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_audit_events_object ON tech_accounting.audit_events USING btree (object_type, object_id);


--
-- TOC entry 4986 (class 1259 OID 62902)
-- Name: idx_desk_attachments_name; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_desk_attachments_name ON tech_accounting.desk_attachments USING btree (original_name);


--
-- TOC entry 4987 (class 1259 OID 62903)
-- Name: idx_desk_attachments_uploaded_at; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_desk_attachments_uploaded_at ON tech_accounting.desk_attachments USING btree (uploaded_at DESC);


--
-- TOC entry 4961 (class 1259 OID 62754)
-- Name: idx_equip_history_equipment_date; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_equip_history_equipment_date ON tech_accounting.equip_history USING btree (equipment_id, changed_at DESC);


--
-- TOC entry 4952 (class 1259 OID 62732)
-- Name: idx_equipment_filters_responsible; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_equipment_filters_responsible ON tech_accounting.equipment USING btree (responsible_user_id, is_archived, is_deleted);


--
-- TOC entry 4953 (class 1259 OID 62731)
-- Name: idx_equipment_filters_status_location; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_equipment_filters_status_location ON tech_accounting.equipment USING btree (status_id, location_id, is_archived, is_deleted);


--
-- TOC entry 4954 (class 1259 OID 62730)
-- Name: idx_equipment_search_inventory; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_equipment_search_inventory ON tech_accounting.equipment USING btree (inventory_number);


--
-- TOC entry 4955 (class 1259 OID 62729)
-- Name: idx_equipment_search_name; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_equipment_search_name ON tech_accounting.equipment USING btree (lower((name)::text));


--
-- TOC entry 5002 (class 1259 OID 62987)
-- Name: idx_import_errors_run_id; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_import_errors_run_id ON tech_accounting.import_errors USING btree (import_run_id);


--
-- TOC entry 4962 (class 1259 OID 62788)
-- Name: idx_part_char_values_equipment; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_part_char_values_equipment ON tech_accounting.part_char_values USING btree (equipment_id);


--
-- TOC entry 4963 (class 1259 OID 62789)
-- Name: idx_part_char_values_part_char; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_part_char_values_part_char ON tech_accounting.part_char_values USING btree (part_id, char_id);


--
-- TOC entry 4988 (class 1259 OID 62930)
-- Name: idx_task_attachments_attachment; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_task_attachments_attachment ON tech_accounting.task_attachments USING btree (attachment_id);


--
-- TOC entry 4989 (class 1259 OID 62929)
-- Name: idx_task_attachments_task; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_task_attachments_task ON tech_accounting.task_attachments USING btree (task_id);


--
-- TOC entry 4978 (class 1259 OID 62879)
-- Name: idx_task_equipment_equipment; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_task_equipment_equipment ON tech_accounting.task_equipment USING btree (equipment_id);


--
-- TOC entry 4979 (class 1259 OID 62878)
-- Name: idx_task_equipment_task; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_task_equipment_task ON tech_accounting.task_equipment USING btree (task_id);


--
-- TOC entry 4975 (class 1259 OID 62849)
-- Name: idx_task_history_task_changed; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_task_history_task_changed ON tech_accounting.task_history USING btree (task_id, changed_at DESC);


--
-- TOC entry 4968 (class 1259 OID 62827)
-- Name: idx_tasks_executor; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_tasks_executor ON tech_accounting.tasks USING btree (executor_id, created_at DESC);


--
-- TOC entry 4969 (class 1259 OID 62828)
-- Name: idx_tasks_requester; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_tasks_requester ON tech_accounting.tasks USING btree (requester_id, created_at DESC);


--
-- TOC entry 4970 (class 1259 OID 62826)
-- Name: idx_tasks_status_created; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE INDEX idx_tasks_status_created ON tech_accounting.tasks USING btree (status_id, created_at DESC);


--
-- TOC entry 4958 (class 1259 OID 62728)
-- Name: uq_equipment_serial_number_not_null; Type: INDEX; Schema: tech_accounting; Owner: postgres
--

CREATE UNIQUE INDEX uq_equipment_serial_number_not_null ON tech_accounting.equipment USING btree (serial_number) WHERE (serial_number IS NOT NULL);


--
-- TOC entry 5053 (class 2620 OID 62997)
-- Name: audit_events trg_audit_events_immutable; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_audit_events_immutable BEFORE DELETE OR UPDATE ON tech_accounting.audit_events FOR EACH ROW EXECUTE FUNCTION tech_accounting.prevent_update_delete();


--
-- TOC entry 5047 (class 2620 OID 62991)
-- Name: dic_equipment_status trg_dic_equipment_status_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_dic_equipment_status_set_updated_at BEFORE UPDATE ON tech_accounting.dic_equipment_status FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5048 (class 2620 OID 62992)
-- Name: dic_task_status trg_dic_task_status_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_dic_task_status_set_updated_at BEFORE UPDATE ON tech_accounting.dic_task_status FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5051 (class 2620 OID 62995)
-- Name: equipment trg_equipment_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_equipment_set_updated_at BEFORE UPDATE ON tech_accounting.equipment FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5046 (class 2620 OID 62990)
-- Name: locations trg_locations_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_locations_set_updated_at BEFORE UPDATE ON tech_accounting.locations FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5044 (class 2620 OID 62988)
-- Name: roles trg_roles_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_roles_set_updated_at BEFORE UPDATE ON tech_accounting.roles FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5050 (class 2620 OID 62994)
-- Name: spr_chars trg_spr_chars_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_spr_chars_set_updated_at BEFORE UPDATE ON tech_accounting.spr_chars FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5049 (class 2620 OID 62993)
-- Name: spr_parts trg_spr_parts_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_spr_parts_set_updated_at BEFORE UPDATE ON tech_accounting.spr_parts FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5052 (class 2620 OID 62996)
-- Name: tasks trg_tasks_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_tasks_set_updated_at BEFORE UPDATE ON tech_accounting.tasks FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5045 (class 2620 OID 62989)
-- Name: users trg_users_set_updated_at; Type: TRIGGER; Schema: tech_accounting; Owner: postgres
--

CREATE TRIGGER trg_users_set_updated_at BEFORE UPDATE ON tech_accounting.users FOR EACH ROW EXECUTE FUNCTION tech_accounting.set_updated_at();


--
-- TOC entry 5041 (class 2606 OID 62942)
-- Name: audit_events audit_events_actor_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.audit_events
    ADD CONSTRAINT audit_events_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5036 (class 2606 OID 62897)
-- Name: desk_attachments desk_attachments_deleted_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.desk_attachments
    ADD CONSTRAINT desk_attachments_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5037 (class 2606 OID 62892)
-- Name: desk_attachments desk_attachments_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.desk_attachments
    ADD CONSTRAINT desk_attachments_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5021 (class 2606 OID 62749)
-- Name: equip_history equip_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equip_history
    ADD CONSTRAINT equip_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5022 (class 2606 OID 62744)
-- Name: equip_history equip_history_equipment_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equip_history
    ADD CONSTRAINT equip_history_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES tech_accounting.equipment(id);


--
-- TOC entry 5016 (class 2606 OID 62718)
-- Name: equipment equipment_created_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5017 (class 2606 OID 62713)
-- Name: equipment equipment_location_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_location_id_fkey FOREIGN KEY (location_id) REFERENCES tech_accounting.locations(id);


--
-- TOC entry 5018 (class 2606 OID 62708)
-- Name: equipment equipment_responsible_user_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_responsible_user_id_fkey FOREIGN KEY (responsible_user_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5019 (class 2606 OID 62703)
-- Name: equipment equipment_status_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_status_id_fkey FOREIGN KEY (status_id) REFERENCES tech_accounting.dic_equipment_status(id);


--
-- TOC entry 5020 (class 2606 OID 62723)
-- Name: equipment equipment_updated_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.equipment
    ADD CONSTRAINT equipment_updated_by_id_fkey FOREIGN KEY (updated_by_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5043 (class 2606 OID 62982)
-- Name: import_errors import_errors_import_run_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_errors
    ADD CONSTRAINT import_errors_import_run_id_fkey FOREIGN KEY (import_run_id) REFERENCES tech_accounting.import_runs(id);


--
-- TOC entry 5042 (class 2606 OID 62967)
-- Name: import_runs import_runs_initiated_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.import_runs
    ADD CONSTRAINT import_runs_initiated_by_fkey FOREIGN KEY (initiated_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5013 (class 2606 OID 62598)
-- Name: locations locations_created_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.locations
    ADD CONSTRAINT locations_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5014 (class 2606 OID 62603)
-- Name: locations locations_updated_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.locations
    ADD CONSTRAINT locations_updated_by_id_fkey FOREIGN KEY (updated_by_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5015 (class 2606 OID 62681)
-- Name: nsi_change_log nsi_change_log_changed_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.nsi_change_log
    ADD CONSTRAINT nsi_change_log_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5023 (class 2606 OID 62778)
-- Name: part_char_values part_char_values_char_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_char_id_fkey FOREIGN KEY (char_id) REFERENCES tech_accounting.spr_chars(id);


--
-- TOC entry 5024 (class 2606 OID 62768)
-- Name: part_char_values part_char_values_equipment_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES tech_accounting.equipment(id);


--
-- TOC entry 5025 (class 2606 OID 62773)
-- Name: part_char_values part_char_values_part_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_part_id_fkey FOREIGN KEY (part_id) REFERENCES tech_accounting.spr_parts(id);


--
-- TOC entry 5026 (class 2606 OID 62783)
-- Name: part_char_values part_char_values_updated_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.part_char_values
    ADD CONSTRAINT part_char_values_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5010 (class 2606 OID 62577)
-- Name: role_permissions role_permissions_granted_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions
    ADD CONSTRAINT role_permissions_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5011 (class 2606 OID 62572)
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES tech_accounting.permissions(id);


--
-- TOC entry 5012 (class 2606 OID 62567)
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES tech_accounting.roles(id);


--
-- TOC entry 5038 (class 2606 OID 62919)
-- Name: task_attachments task_attachments_attachment_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments
    ADD CONSTRAINT task_attachments_attachment_id_fkey FOREIGN KEY (attachment_id) REFERENCES tech_accounting.desk_attachments(id);


--
-- TOC entry 5039 (class 2606 OID 62924)
-- Name: task_attachments task_attachments_linked_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments
    ADD CONSTRAINT task_attachments_linked_by_fkey FOREIGN KEY (linked_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5040 (class 2606 OID 62914)
-- Name: task_attachments task_attachments_task_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_attachments
    ADD CONSTRAINT task_attachments_task_id_fkey FOREIGN KEY (task_id) REFERENCES tech_accounting.tasks(id);


--
-- TOC entry 5033 (class 2606 OID 62868)
-- Name: task_equipment task_equipment_equipment_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment
    ADD CONSTRAINT task_equipment_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES tech_accounting.equipment(id);


--
-- TOC entry 5034 (class 2606 OID 62873)
-- Name: task_equipment task_equipment_linked_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment
    ADD CONSTRAINT task_equipment_linked_by_fkey FOREIGN KEY (linked_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5035 (class 2606 OID 62863)
-- Name: task_equipment task_equipment_task_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_equipment
    ADD CONSTRAINT task_equipment_task_id_fkey FOREIGN KEY (task_id) REFERENCES tech_accounting.tasks(id);


--
-- TOC entry 5031 (class 2606 OID 62844)
-- Name: task_history task_history_changed_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_history
    ADD CONSTRAINT task_history_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5032 (class 2606 OID 62839)
-- Name: task_history task_history_task_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.task_history
    ADD CONSTRAINT task_history_task_id_fkey FOREIGN KEY (task_id) REFERENCES tech_accounting.tasks(id);


--
-- TOC entry 5027 (class 2606 OID 62821)
-- Name: tasks tasks_deleted_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_deleted_by_fkey FOREIGN KEY (deleted_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5028 (class 2606 OID 62816)
-- Name: tasks tasks_executor_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_executor_id_fkey FOREIGN KEY (executor_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5029 (class 2606 OID 62811)
-- Name: tasks tasks_requester_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_requester_id_fkey FOREIGN KEY (requester_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5030 (class 2606 OID 62806)
-- Name: tasks tasks_status_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.tasks
    ADD CONSTRAINT tasks_status_id_fkey FOREIGN KEY (status_id) REFERENCES tech_accounting.dic_task_status(id);


--
-- TOC entry 5007 (class 2606 OID 62552)
-- Name: user_roles user_roles_assigned_by_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles
    ADD CONSTRAINT user_roles_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5008 (class 2606 OID 62547)
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES tech_accounting.roles(id);


--
-- TOC entry 5009 (class 2606 OID 62542)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5005 (class 2606 OID 62521)
-- Name: users users_created_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.users
    ADD CONSTRAINT users_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES tech_accounting.users(id);


--
-- TOC entry 5006 (class 2606 OID 62526)
-- Name: users users_updated_by_id_fkey; Type: FK CONSTRAINT; Schema: tech_accounting; Owner: postgres
--

ALTER TABLE ONLY tech_accounting.users
    ADD CONSTRAINT users_updated_by_id_fkey FOREIGN KEY (updated_by_id) REFERENCES tech_accounting.users(id);


-- Completed on 2026-02-12 12:03:45

--
-- PostgreSQL database dump complete
--

