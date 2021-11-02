require 'pg'
require 'erb'
require 'json'

class InstallationReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    @office = db.exec("SELECT * FROM offices WHERE id = #{env['rack.route_params'][:id]};")[0]

    zones =  db.exec("SELECT * FROM zones WHERE office_id = #{env['rack.route_params'][:id]};")


    rooms = {}
    zones.each do |zone|
      rooms[zone["type"]] = db.exec("SELECT * FROM rooms WHERE zone_id = #{zone["id"]};")
    end

    @data_by_office = {}

    rooms.each do |k,v|
      material = {}
      v.each do |room|
        material_fix = db.exec("SELECT mm.type m_type, mm.name m_name,
                                             fix.name f_name, fix.type f_type
                        FROM( (rooms INNER JOIN fixtures fix ON rooms.id = fix.room_id)
                        INNER JOIN marketing_materials mm ON fix.id = mm.fixture_id)
                        WHERE rooms.id = #{room["id"]};"
        )

        material.store(room["name"], material_fix)
        @data_by_office[k]=material
      end
    end



    @count = db.exec("SELECT SUM(rooms.area) area, SUM(rooms.max_people) max_people
            FROM (rooms INNER JOIN zones ON rooms.zone_id = zones.id)
            WHERE zones.office_id = #{env['rack.route_params'][:id]};")[0]



    template = File.read("./App/templates/office_installation.erb")
    content = ERB.new(template)
    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end
end