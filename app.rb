require 'csv'

class App
  def call(env)
    req = Rack::Request.new(env)
    if req.post?
      if req.params['file']
        table = CSV.parse(File.read(req.params['file'][:tempfile]), headers: true)
        table.by_row.each do |data|
          begin
            office = $conn.exec("INSERT INTO offices (title, address, city, state, phone, LOB, type)
              VALUES (
                '#{data['Office']}',
                '#{data['Office address']}',
                '#{data['Office city']}',
                '#{data['Office State']}',
                #{data['Office phone'].to_i},
                '#{data['Office lob']}',
                '#{data['Office type']}')
                returning id;")
            zone = $conn.exec("INSERT INTO zones (office_id, type)
                      VALUES (
                        '#{office[0]['id']}',
                        '#{data['Zone']}'
                        )
                        returning id;")
            room = $conn.exec(
              "INSERT INTO rooms (zone_id, name, area, max_people)
                        VALUES (
                          '#{zone[0]['id']}',
                          '#{data['Room']}',
                          '#{data['Room area']}',
                          '#{data['Room max people']}'
                          ) returning id;")

            fixture = $conn.exec(
              "INSERT INTO fixtures (room_id, name, type) VALUES
                          ('#{room[0]['id']}',
                            '#{data['Fixture']}',
                          '#{data['Fixture Type']}'
                          ) returning id;")

            $conn.exec(
              "INSERT INTO marketing_materials (fixture_id, name, cost, type) VALUES
                          ('#{fixture[0]['id']}',
                            '#{data['Marketing material']}',
                            '#{data['Marketing material cost']}',
                          '#{data['Marketing material type']}'
                          ) returning id;")
          rescue PG::UniqueViolation
            next
          end

        end
        puts 'suck'
      end
      return [400, { "Content-Type" => "text/html" }, ["<h1>Bad req</h1>"]]

    end
    status = 200
    headers = { "Content-Type" => "text/html" }
    body = [
      "<h1>Upload file</h1>
      <form method='post' enctype='multipart/form-data'>
       <div>
         <label for='file'>Choose file to upload</label>
         <input type='file' id='file' name='file' multiple>
       </div>
       <div>
         <button>Submit</button>
       </div>
      </form>"
    ]

    [status, headers, body]
  end
end