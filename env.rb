# frozen_string_literal: true

require 'bundler/setup'
require 'csv'
require 'json'

Bundler.require(:default)

DB = PG::Connection.open(dbname: 'Task_one', password: '12345678')

DB.exec("SELECT 'test'") do
  puts '################################'
  puts
  puts 'Succeeded connection to database'
  puts
  puts '################################'
end
