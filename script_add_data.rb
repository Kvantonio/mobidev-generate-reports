require 'pg'

db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

db.exec("INSERT INTO offices (title, address, city, state, phone, LOB, type) VALUES
 ('value1', 'value2', 'value3', 'value4', 1212121, 'value6', 'alue7')
;")

db.exec("INSERT INTO zones (office_id, type) VALUES
 (1, 'value2')
;")

db.exec("INSERT INTO rooms (zone_id, name, area, max_people) VALUES
 (1, 'room', 100, 5)
;")

db.exec("INSERT INTO fixtures (rooms_id, name, type) VALUES
(1, 'fix', 'Door');")

db.exec("INSERT INTO marketing_materials (fixture_id, name, cost, type) VALUES
 (1, 'mark_mat', 3, 'type')
;")
