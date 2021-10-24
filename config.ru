require_relative 'app'
my_app = Rack::URLMap.new('/index'=>App.new)
run my_app