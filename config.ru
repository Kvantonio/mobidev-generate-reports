require_relative 'app'

my_app = Rack::URLMap.new('/'=>App.new)
run my_app