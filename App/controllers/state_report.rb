# frozen_string_literal: true

require 'pg'
require 'erb'

class StateReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: '12345678')

    if !env['rack.route_params'][:state]

      states = db.exec('SELECT DISTINCT state FROM offices;')
      @res = []
      states.each do |state|
        @res << db.exec("SELECT * FROM offices WHERE state='#{state['state']}'")
      end

    else
      @res = db.exec_params('Select * from offices where state=$1', [env['rack.route_params'][:state].upcase])

      return [400, { 'Content-Type' => 'text/html' }, ['<h1>No information</h1>']] unless @res.first

      @res = [@res]
    end
    template = File.read('./App/templates/states_report.erb')
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
