# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class StateReport
  def call(env)
    if !env['rack.route_params'][:state]

      offices = DB.exec('SELECT * FROM offices;')
      @res = {}
      offices.each do |office|
        if @res[office["state"]]
          @res[office["state"]] << office
        else
          @res[office["state"]] = [office]
        end
      end

    else
      @res = DB.exec_params('Select * from offices where state=$1', [env['rack.route_params'][:state].upcase])

      return [400, { 'Content-Type' => 'text/html' }, ['<h1>No information</h1>']] unless @res.first

      @res = [@res]
    end
    template = File.read(File.join(File.dirname(__FILE__), '../templates/states_report.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
