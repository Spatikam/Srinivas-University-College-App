-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.
-- I used Supabase's "Copy as SQL" feature in the Database > Schema Visualizer menu to generate this from the existing tables.
-- We used the GUI to create the tables, set constraints and define RLS policies for RBAC

CREATE TABLE public.APIKEY (
  id smallint GENERATED ALWAYS AS IDENTITY NOT NULL UNIQUE,
  key uuid DEFAULT gen_random_uuid(),
  CONSTRAINT APIKEY_pkey PRIMARY KEY (id)
);
CREATE TABLE public.Announcements (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  Name character varying NOT NULL,
  Created_At timestamp without time zone DEFAULT (now() AT TIME ZONE 'utc-5:30'::text),
  Description character varying,
  Type text NOT NULL,
  Delete_At timestamp without time zone,
  owner_id uuid DEFAULT auth.uid(),
  CONSTRAINT Announcements_pkey PRIMARY KEY (id)
);
CREATE TABLE public.Articles (
  Article_id uuid NOT NULL DEFAULT gen_random_uuid(),
  Heading character varying NOT NULL,
  Published_by character varying NOT NULL,
  Image_path character varying,
  Description character varying,
  op_id uuid DEFAULT auth.uid(),
  CONSTRAINT Articles_pkey PRIMARY KEY (Article_id)
);
CREATE TABLE public.Events (
  Event_Id uuid NOT NULL DEFAULT gen_random_uuid(),
  Name character varying NOT NULL,
  Start_date date,
  Start_time time without time zone,
  End_date date,
  End_time time without time zone,
  Venue character varying,
  Description character varying NOT NULL,
  Link character varying,
  Contact bigint,
  Poster_path character varying,
  created_by uuid NOT NULL DEFAULT auth.uid(),
  Attachment_path character varying,
  CONSTRAINT Events_pkey PRIMARY KEY (Event_Id)
);
CREATE TABLE public.Gallery (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  Filename character varying NOT NULL,
  Created_by uuid NOT NULL DEFAULT auth.uid(),
  CONSTRAINT Gallery_pkey PRIMARY KEY (id)
);
CREATE TABLE public.Placements (
  Placement_Id uuid NOT NULL DEFAULT gen_random_uuid(),
  Name character varying NOT NULL,
  LPA real,
  Company_Name character varying,
  Uploaded_by uuid NOT NULL DEFAULT auth.uid(),
  Link character varying,
  CONSTRAINT Placements_pkey PRIMARY KEY (Placement_Id)
);
CREATE TABLE public.Users (
  Name text NOT NULL UNIQUE,
  College text NOT NULL UNIQUE,
  Department text,
  Designation character varying,
  uuid uuid NOT NULL DEFAULT auth.uid() UNIQUE,
  CONSTRAINT Users_pkey PRIMARY KEY (uuid),
  CONSTRAINT Users_uuid_fkey FOREIGN KEY (uuid) REFERENCES auth.users(id)
);
