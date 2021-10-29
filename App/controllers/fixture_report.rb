require 'pg'
require 'erb'

class FixtureReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")
    @offices_by_fixture_type = get_offices_by_type db
    if !@offices_by_fixture_type
      return [403, { "Content-Type" => "text/html" }, ["<h1>No data!</h1>"]]
    end
    @total_count = total_count @offices_by_fixture_type

    template = File.read("./App/templates/fixture_report.erb")
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