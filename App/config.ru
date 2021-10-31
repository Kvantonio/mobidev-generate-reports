require 'rack/router'

require_relative 'controllers/upload_data'
require_relative 'controllers/state_report'
require_relative 'controllers/fixture_report'
require_relative 'controllers/marketing_cost_report'

my_app = Rack::Router.new {
  get '/'=>UploadData.new
  post '/'=>UploadData.new
  get '/reports/states/'=>StateReport.new
  get '/reports/states/:state'=>StateReport.new
  get '/reports/offices/fixture_types'=>FixtureReport.new
  get '/reports/offices/:id/fixture_types'=>FixtureReport.new
  get '/reports/offices/marketing_materials'=>CostReport.new
}

use Rack::Static,
    :urls =>  ["/css"],
    :root => "./App/public"

run my_app