require 'csv'
require 'erb'

require_relative './modules/insert_module'

class UploadData
  include InsertData

  def call(env)
    req = Rack::Request.new(env)
    if req.post?
      unless req.params['file']
        return [400, { 'Content-Type' => 'text/html' }, ['<h1>Bad req</h1>']]
      end
      table = CSV.parse(File.read(req.params['file'][:tempfile]), headers: true)
      pars_and_add table
    end



    template = File.read('./App/templates/upload.erb')
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
