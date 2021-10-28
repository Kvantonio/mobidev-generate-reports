require 'pg'
require 'erb'

class FixtureReport
  def call(env)
    @offices_by_fixture_type = get_offices_by_type

    @offices_by_fixture_type.each do |k, v|
      @offices_by_fixture_type[k] = v.inject(Hash.new(0)) { |value, i| value[i] += 1; value }
    end

    @total_count = total_count @offices_by_fixture_type

    template = File.read("./App/templates/fixture_report.erb")
    content = ERB.new(template)
    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  end

  def get_offices_by_type
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    fixtures = db.exec_params("SELECT * FROM fixtures")
    offices_by_fixture_type = {}
    fixtures.each do |fix|
      offices_by_fixture_type[fix["type"]] = []
    end

    fixtures.each_with_index do |fixture, i|
      offices = db.exec("SELECT * FROM offices WHERE id = (
          SELECT office_id FROM zones WHERE id = (
              SELECT zone_id FROM rooms WHERE id = #{fixture["room_id"]}
           )
          )")

      offices_by_fixture_type[fixtures[i]["type"]] << offices[0]
    end
    offices_by_fixture_type
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