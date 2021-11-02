require 'rack/router'

require_relative 'controllers/upload_data'
require_relative 'controllers/state_report'
require_relative 'controllers/fixture_report'
require_relative 'controllers/marketing_cost_report'
require_relative 'controllers/search_office'
require_relative 'controllers/office_installation_report'
require_relative 'controllers/root'

my_app = Rack::Router.new {
  get '/'=>Root.new

  get '/upload_data/'=>UploadData.new
  post '/upload_data/'=>UploadData.new
  get '/reports/states/'=>StateReport.new
  get '/reports/states/:state'=>StateReport.new
  get '/reports/offices/fixture_types'=>FixtureReport.new
  get '/reports/offices/:id/fixture_types'=>FixtureReport.new
  get '/reports/offices/marketing_materials'=>CostReport.new

  get '/reports/offices/installation'=>SearchOffices.new
  post '/reports/offices/installation'=>SearchOffices.new

  get '/reports/offices/:id/installation'=>InstallationReport.new

}

use Rack::Static,
    :urls =>  ["/css"],
    :root => "./App/public"

run my_app