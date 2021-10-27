require 'pg'
require 'erb'

class StateReport
  def call(env)
    req = Rack::Request.new(env)

    template = File.read("./App/templates/states_report.erb")
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    if !req.path.split('/')[3]
      #TODO: do page with all states information
      return [200, { "Content-Type" => "text/html" }, ["fix this"]]

    else
      @res = db.exec_params("Select * from offices where state=$1", [req.path.split('/')[3].upcase])

      if @res.first
        content = ERB.new(template)
      else
        return [400, { "Content-Type" => "text/html" }, ["<h1>No information</h1>"]]
      end

    end

    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end