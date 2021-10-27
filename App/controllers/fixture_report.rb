require 'pg'
require 'erb'

class FixtureReport
  def call(env)
    req = Rack::Request.new(env)

    puts req.path

    [200, { "Content-Type" => "text/html" }, ["Goood"]]
  end
end