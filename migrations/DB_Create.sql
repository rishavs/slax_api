BEGIN;

DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS users;

DROP INDEX IF EXISTS posts_id_index;
DROP INDEX IF EXISTS users_id_index;

ALTER SEQUENCE IF EXISTS posts_id_seq RESTART WITH 1;
ALTER SEQUENCE IF EXISTS users_id_seq RESTART WITH 1;

CREATE TABLE users(
    id INTEGER NOT NULL,

    name character varying NOT NULL,
    email character varying NOT NULL,
    gender INTEGER,
    is_adult BOOL DEFAULT FALSE,
    is_admin BOOL DEFAULT FALSE,
    is_mod BOOL DEFAULT FALSE,
    is_loggedin BOOL DEFAULT FALSE,
    auth_provider character varying,
    client_id character varying,
    token character varying,
    last_active_at timestamp without time zone,

    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;
ALTER TABLE ONLY users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
CREATE UNIQUE INDEX users_id_index ON users (id);


CREATE TABLE posts(
    id INTEGER NOT NULL,

    user_id INTEGER references users(id),
    title character varying,
    is_link BOOL,
    link character varying,
    content text,
    is_viewable BOOL DEFAULT FALSE,
    is_approved BOOL DEFAULT FALSE,
    is_deleted BOOL DEFAULT FALSE,
    last_read_at timestamp without time zone,

    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    CACHE 1;

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;
ALTER TABLE ONLY posts ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);
CREATE UNIQUE INDEX posts_id_index ON posts (id);


COMMIT;
