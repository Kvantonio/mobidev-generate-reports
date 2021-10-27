require_relative 'controllers/upload_data'
require_relative 'controllers/state_report'

my_app = Rack::URLMap.new(
  '/'=>UploadData.new,
  '/reports/states/'=>StateReport.new
)

run my_app