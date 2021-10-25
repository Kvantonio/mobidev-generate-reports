require 'csv'
require 'pg'
require_relative 'script_add_data'
class App
  include InsertData
  def call(env)
    req = Rack::Request.new(env)
    if req.post?

      if req.params['file']
        table = CSV.parse(File.read(req.params['file'][:tempfile]), headers: true)
        pars table
      else
        return [400, { "Content-Type" => "text/html" }, ["<h1>Bad req</h1>"]]
      end


    end
    status = 200
    headers = { "Content-Type" => "text/html" }
    body = [
      "<h1>Upload file</h1>
      <form method='post' enctype='multipart/form-data'>
       <div>
         <label for='file'>Choose file to upload</label>
         <input type='file' id='file' name='file' multiple required>
       </div>
       <div>
         <button>Submit</button>
       </div>
      </form>"
    ]

    [status, headers, body]
  end
end