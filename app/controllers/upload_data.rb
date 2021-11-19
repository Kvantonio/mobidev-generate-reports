# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')
require_relative './modules/insert_module'

class UploadData
  include InsertModule

  def call(env)
    req = Rack::Request.new(env)
    if req.post?
      return [400, { 'Content-Type' => 'text/html' }, ['<h1>Bad req</h1>']] unless req.params['file']

      table = CSV.parse(File.read(req.params['file'][:tempfile]), headers: true)
      pars_and_add table
    end

    template = File.read(File.join(File.dirname(__FILE__), '../templates/upload.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
