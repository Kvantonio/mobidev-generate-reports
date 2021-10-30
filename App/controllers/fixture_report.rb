require 'pg'
require 'erb'

class FixtureReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")
    if !env['rack.route_params'][:id]
      @offices_by_fixture_type = get_offices_by_type db
      if !@offices_by_fixture_type
        return [403, { "Content-Type" => "text/html" }, ["<h1>No data!</h1>"]]
      end
      @total_count = total_count @offices_by_fixture_type
      template = File.read("./App/templates/fixture_report.erb")
    else

      @office_title = db.exec("SELECT title FROM offices WHERE id = #{env['rack.route_params'][:id].to_i}")
      unless @office_title.first
        return [403, { "Content-Type" => "text/html" }, ["<h1>No office with this id </h1>"]]
      end
      @office_title = @office_title[0]["title"]
      @fixtures_by_office = db.exec("SELECT offices.title, fixtures.type
         FROM ((( offices
         INNER JOIN zones ON offices.id = zones.office_id)
         INNER JOIN rooms ON zones.id = rooms.zone_id)
         INNER JOIN fixtures ON rooms.id = fixtures.room_id)
         WHERE offices.id = #{env['rack.route_params'][:id].to_i};
         ")

      @data = {}
      @fixtures_by_office.each do |v|
        if @data[v["type"]]
          @data[v["type"]] += 1
        else
          @data[v["type"]] =1
        end
      end



      template = File.read("./App/templates/fixture_report_by_office.erb")
    end

    content = ERB.new(template)
    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end

  def get_offices_by_type(db_connection)
    fixtures = db_connection.exec_params("SELECT * FROM fixtures")

    unless fixtures.first
      return nil
    end
    data = {}
    fixtures.each do |fix|
      data[fix["type"]] = []
    end

    fixtures.each_with_index do |fixture, i|
      offices = db_connection.exec("SELECT * FROM offices WHERE id = (
          SELECT office_id FROM zones WHERE id = (
              SELECT zone_id FROM rooms WHERE id = #{fixture["room_id"]}
           )
          )")
      data[fixtures[i]["type"]] << offices[0]
    end

    data.each do |k, v|
      data[k] = v.inject(Hash.new(0)) { |value, i| value[i] += 1; value }
    end

    data
  end

  def total_count(fixtures_data)
    total_count = []
    fixtures_data.each do |k, v, t = 0|
      v.each { |_, cost| t += cost }
      total_count.push(t)
    end
    total_count
  end

end