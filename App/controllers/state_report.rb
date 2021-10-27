require 'pg'
require 'erb'

class StateReport
  def call(env)
    req = Rack::Request.new(env)

    template = File.read("./App/templates/states_report.erb")
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    if !env['rack.route_params'][:state]

      states = db.exec("SELECT DISTINCT state FROM offices;")
      @res= []
      states.each do |state|
        @res << db.exec("SELECT * FROM offices WHERE state='#{state["state"]}'")
      end
      content = ERB.new(template)


    else
      @res = db.exec_params("Select * from offices where state=$1", [env['rack.route_params'][:state].upcase])

      if @res.first
        @res= [@res]
        content = ERB.new(template)
      else
        return [400, { "Content-Type" => "text/html" }, ["<h1>No information</h1>"]]
      end

    end

    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end