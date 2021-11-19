# frozen_string_literal: true

require_relative './env'

DB.exec('DROP SCHEMA public CASCADE;')
DB.exec('CREATE SCHEMA public;')
