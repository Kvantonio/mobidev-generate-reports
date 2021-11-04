# frozen_string_literal: true

require 'pg'

db = PG::Connection.open(dbname: 'Task_one', password: '12345678')

db.exec('DROP SCHEMA public CASCADE;')
db.exec('CREATE SCHEMA public;')
