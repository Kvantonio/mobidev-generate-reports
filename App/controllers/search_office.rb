require 'pg'
require 'erb'

class SearchOffices
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")
    req = Rack::Request.new(env)

    if req.post?

    else
      @offices = db.exec("SELECT id, title FROM offices;")
    end





    template = File.read("./App/templates/search_offices_reports.erb")
    content = ERB.new(template)
    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end