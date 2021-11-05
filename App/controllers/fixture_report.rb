# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class FixtureReport
  def call(env)
    if !env['rack.route_params'][:id]
      @offices_by_fixture_type = get_offices_by_type

      return [403, { 'Content-Type' => 'text/html' }, ['<h1>No data!</h1>']] unless @offices_by_fixture_type

      @total_count = total_count @offices_by_fixture_type

      template = File.read(File.join(File.dirname(__FILE__), '../templates/fixture_report.erb'))
    else

      @office_title = DB.exec("SELECT title FROM offices WHERE id =
                              #{env['rack.route_params'][:id].to_i}")
      return [403, { 'Content-Type' => 'text/html' }, ['<h1>No office with this id </h1>']] unless @office_title.first

      @office_title = @office_title[0]['title']
      @data = get_fixtures_by_office env['rack.route_params'][:id].to_i

      template = File.read(File.join(File.dirname(__FILE__), '../templates/fixture_report_by_office.erb'))
    end

    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end

  def get_offices_by_type
    fixtures = DB.exec_params('SELECT * FROM fixtures')

    return nil unless fixtures.first

    data = {}
    fixtures.each do |fix|
      data[fix['type']] = []
    end

    fixtures.each_with_index do |fixture, i|
      offices = DB.exec("SELECT * FROM offices WHERE id = (
          SELECT office_id FROM zones WHERE id = (
              SELECT zone_id FROM rooms WHERE id = #{fixture['room_id']}
           )
          )")
      data[fixtures[i]['type']] << offices[0]
    end

    data.each do |k, v|
      data[k] = v.each_with_object(Hash.new(0)) do |i, value|
        value[i] += 1
      end
    end
    data
  end

  def total_count(fixtures_data)
    total_count = []
    fixtures_data.each do |_k, v, t = 0|
      v.each { |_, cost| t += cost }
      total_count.push(t)
    end
    total_count
  end

  def get_fixtures_by_office(office_id)
    fixtures_by_office = DB.exec("SELECT offices.title, fixtures.type
         FROM ((( offices
         INNER JOIN zones ON offices.id = zones.office_id)
         INNER JOIN rooms ON zones.id = rooms.zone_id)
         INNER JOIN fixtures ON rooms.id = fixtures.room_id)
         WHERE offices.id = #{office_id};
         ")

    data = {}
    fixtures_by_office.each do |v|
      if data[v['type']]
        data[v['type']] += 1
      else
        data[v['type']] = 1
      end
    end
    data
  end
end
