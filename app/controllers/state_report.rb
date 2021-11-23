# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class StateReport
  def call(env)
    req_state = env['rack.route_params'][:state]
    @res = {}
    if !req_state

      offices = DB.exec('SELECT * FROM offices;')
      offices.each do |office|
        if @res[office['state']]
          @res[office['state']] << office
        else
          @res[office['state']] = [office]
        end
      end

    else
      offices = DB.exec_params('Select * from offices where state=$1', [req_state.upcase])

      return [400, { 'Content-Type' => 'text/html' }, ['<h1>No information</h1>']] unless offices.first

      @res[req_state.upcase] = offices
    end
    template = File.read(File.join(File.dirname(__FILE__), '../templates/states_report.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
