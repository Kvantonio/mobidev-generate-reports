require 'rack/router'

require_relative 'controllers/upload_data'
require_relative 'controllers/state_report'
require_relative 'controllers/fixture_report'

my_app = Rack::Router.new {
  get '/'=>UploadData.new
  get '/reports/states/'=>StateReport.new
  get '/reports/states/:state'=>StateReport.new
  get '/reports/offices/:id/fixture_types'=>FixtureReport.new
}

run my_app