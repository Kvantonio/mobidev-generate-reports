require 'pg'
require 'erb'

class Root
  def call(env)



    # template = File.read("./App/templates/materials_report.erb")
    # content = ERB.new(template)
    # [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end