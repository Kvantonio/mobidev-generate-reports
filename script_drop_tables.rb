# frozen_string_literal: true

require_relative  './env.rb'

DB.exec('DROP SCHEMA public CASCADE;')
DB.exec('CREATE SCHEMA public;')
