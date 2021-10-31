require 'pg'
require 'erb'

class InstallationReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    # @data_by_office = db.exec()

    # template = File.read("./App/templates/materials_report.erb")
    # content = ERB.new(template)
    # [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end