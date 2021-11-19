# frozen_string_literal: true

require_relative './env'

DB.exec("
DO $$ BEGIN
    CREATE TYPE fixtures_type AS ENUM (
      'Door',
      'Window',
      'Wall poster',
      'Table',
      'ATM Wall',
      'Flag',
      'Standing desk'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;")

DB.exec('CREATE TABLE IF NOT EXISTS "offices" (
    "id" SERIAL PRIMARY KEY,
    "title" varchar NOT NULL,
    "address" varchar NOT NULL,
    "city" varchar NOT NULL,
    "state" varchar NOT NULL,
    "phone" bigint NOT NULL,
    "lob" varchar NOT NULL,
    "type" varchar NOT NULL,
    UNIQUE("title", "address", "city", "state", "phone")
  );
do $$
begin
raise info \'Table "offices" created:  %\', now();
end $$;
')

DB.exec('CREATE TABLE IF NOT EXISTS "zones" (
    "id" SERIAL PRIMARY KEY,
    "office_id" int NOT NULL REFERENCES offices (id) ON DELETE CASCADE,
    "type" varchar NOT NULL,
    UNIQUE(office_id, type)
  );
do $$
begin
raise info \'Table "zones" created:  %\', now();
end $$;
')

DB.exec('CREATE TABLE IF NOT EXISTS "rooms" (
    "id" SERIAL PRIMARY KEY,
    "zone_id" int NOT NULL REFERENCES zones (id) ON DELETE CASCADE,
    "name" varchar NOT NULL,
    "area" int NOT NULL,
    "max_people" int NOT NULL,
    UNIQUE(zone_id, name)
  );
do $$
begin
raise info \'Table "rooms" created:  %\', now();
end $$;
')

DB.exec("CREATE TABLE IF NOT EXISTS fixtures (
    id SERIAL PRIMARY KEY,
    room_id int NOT NULL REFERENCES rooms (id) ON DELETE CASCADE,
    name varchar NOT NULL,
    \"type\" fixtures_type
  );
do $$
begin
raise info 'Table \"fixtures\" created:  %', now();
end $$;
")

# DB.exec("CREATE TABLE IF NOT EXISTS fixtures (
#     id SERIAL PRIMARY KEY,
#     room_id int NOT NULL REFERENCES rooms (id) ON DELETE CASCADE,
#     name varchar NOT NULL,
#     \"type\" text CHECK(array_position(ARRAY['Door', 'Window', 'Wall poster', 'Table'], \"type\") IS NOT NULL )
#   );")
DB.exec('CREATE TABLE IF NOT EXISTS "marketing_materials" (
    id SERIAL PRIMARY KEY,
    fixture_id int NOT NULL UNIQUE REFERENCES fixtures (id) ON DELETE CASCADE,
    name varchar NOT NULL,
    cost float NOT NULL,
    type varchar NOT NULL
  );
do $$
begin
raise info \'Table "marketing_materials" created:  %\', now();
end $$;
')

DB.exec("ALTER TABLE offices ADD COLUMN IF NOT EXISTS ts_q tsvector
         GENERATED ALWAYS AS
             (setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
              setweight(to_tsvector('english', coalesce(address, '')), 'B')) STORED;")

DB.exec('ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id");')

DB.exec('ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");')

DB.exec('ALTER TABLE "fixtures" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");')

DB.exec('ALTER TABLE "marketing_materials" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixtures" ("id");')
