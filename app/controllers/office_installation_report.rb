# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class InstallationReport
  def call(env)
    @office = DB.exec("SELECT * FROM offices WHERE id = #{env['rack.route_params'][:id]};")[0]

    zones = DB.exec("SELECT * FROM zones WHERE office_id = #{env['rack.route_params'][:id]};")

    rooms = {}
    zones.each do |zone|
      rooms[zone['type']] = DB.exec("SELECT * FROM rooms WHERE zone_id = #{zone['id']};")
    end

    @data_by_office = {}

    rooms.each do |k, v|
      material = {}
      v.each do |room|
        material_fix = DB.exec("SELECT mm.type m_type, mm.name m_name,
                                             fix.name f_name, fix.type f_type
                        FROM( (rooms INNER JOIN fixtures fix ON rooms.id = fix.room_id)
                        INNER JOIN marketing_materials mm ON fix.id = mm.fixture_id)
                        WHERE rooms.id = #{room['id']};")

        material.store(room['name'], material_fix)
        @data_by_office[k] = material
      end
    end

    @count = DB.exec("SELECT SUM(rooms.area) area, SUM(rooms.max_people) max_people
            FROM (rooms INNER JOIN zones ON rooms.zone_id = zones.id)
            WHERE zones.office_id = #{env['rack.route_params'][:id]};")[0]

    template = File.read(File.join(File.dirname(__FILE__), '../templates/office_installation.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
