# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class SearchOffices
  def call(env)
    req = Rack::Request.new(env)

    @offices = if req.post? && !req.POST['search'].empty?
                 DB.exec("SELECT * FROM offices
                           WHERE ts_q @@ to_tsquery('english', '#{req.POST['search']}');")
               else
                 DB.exec('SELECT id, title, address FROM offices;')
               end

    template = File.read(File.join(File.dirname(__FILE__), '../templates/search_offices_reports.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
