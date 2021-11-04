# frozen_string_literal: true

require 'pg'
require 'erb'

class SearchOffices
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: '12345678')
    req = Rack::Request.new(env)

    @offices = if req.post? && req.POST['search'].empty?
                 db.exec("SELECT * FROM offices
                           WHERE ts_q @@ to_tsquery('english', '#{req.POST['search']}');")
               else
                 db.exec('SELECT id, title, address FROM offices;')
               end

    template = File.read('./App/templates/search_offices_reports.erb')
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
