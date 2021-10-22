CREATE TYPE "fixtures_type" AS ENUM (
  'Door',
  'Window',
  'Wall poster',
  'Table',
  'ATM Wall',
  'Flag',
  'Standing desk'
);

CREATE TABLE "offices" (
  "id" int PRIMARY KEY,
  "title" varchar NOT NULL,
  "address" varchar,
  "city" varchar,
  "state" varchar,
  "phone" int,
  "LOB" varchar,
  "type" varchar
);

CREATE TABLE "rooms" (
  "id" int PRIMARY KEY,
  "zone_id" int NOT NULL,
  "name" varchar,
  "area" int,
  "max_people" int
);

CREATE TABLE "zones" (
  "id" int PRIMARY KEY,
  "office_id" int NOT NULL,
  "type" varchar NOT NULL
);

CREATE TABLE "fixtures" (
  "id" int PRIMARY KEY,
  "rooms_id" int NOT NULL,
  "name" varchar,
  "type" fixtures_type
);

CREATE TABLE "marketing_materials" (
  "id" int PRIMARY KEY,
  "fixture_id" int NOT NULL,
  "name" varchar,
  "cost" float,
  "type" varchar
);

ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id");

ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");

ALTER TABLE "fixtures" ADD FOREIGN KEY ("rooms_id") REFERENCES "rooms" ("id");

ALTER TABLE "fixtures" ADD FOREIGN KEY ("id") REFERENCES "marketing_materials" ("fixture_id");
