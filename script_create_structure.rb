require 'pg'

db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

db.exec('CREATE TABLE IF NOT EXISTS "offices" (
    "id" SERIAL PRIMARY KEY,
    "title" varchar NOT NULL,
    "address" varchar NOT NULL,
    "city" varchar NOT NULL,
    "state" varchar NOT NULL,
    "phone" int NOT NULL,
    "lob" varchar NOT NULL,
    "type" varchar NOT NULL
  );')

db.exec('CREATE TABLE IF NOT EXISTS "zones" (
    "id" SERIAL PRIMARY KEY,
    "office_id" int NOT NULL REFERENCES offices (id) ON DELETE CASCADE,
    "type" varchar NOT NULL
  );')

db.exec('CREATE TABLE IF NOT EXISTS "rooms" (
    "id" SERIAL PRIMARY KEY,
    "zone_id" int NOT NULL REFERENCES zones (id) ON DELETE CASCADE,
    "name" varchar NOT NULL,
    "area" int NOT NULL,
    "max_people" int NOT NULL
  );')

db.exec("CREATE TABLE IF NOT EXISTS fixtures (
    id SERIAL PRIMARY KEY,
    rooms_id int NOT NULL REFERENCES rooms (id) ON DELETE CASCADE,
    name varchar NOT NULL,
    \"type\" text CHECK(array_position(ARRAY['Door', 'Window', 'Wall poster', 'Table'], \"type\") IS NOT NULL )
  );")
db.exec('CREATE TABLE IF NOT EXISTS "marketing_materials" (
    "id" SERIAL PRIMARY KEY,
    "fixture_id" int NOT NULL UNIQUE REFERENCES fixtures (id) ON DELETE CASCADE,
    "name" varchar NOT NULL,
    "cost" float NOT NULL,
    "type" varchar NOT NULL
  );')

db.exec('ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id");')

db.exec('ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");')

db.exec('ALTER TABLE "fixtures" ADD FOREIGN KEY ("rooms_id") REFERENCES "rooms" ("id");')

db.exec('ALTER TABLE "marketing_materials" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixtures" ("id");')
