require 'pg'
require 'erb'

class CostReport
  def call(env)
    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    @data_cost = {}

    offices = db.exec("SELECT id, title FROM offices;")
    @temp = {}
    offices.each do |office|
      @data_cost[office["title"]] = {}
      @temp[office["title"]] = db.exec("SELECT marketing_materials.type, marketing_materials.cost
         FROM (((( offices
         INNER JOIN zones ON offices.id = zones.office_id)
         INNER JOIN rooms ON zones.id = rooms.zone_id)
         INNER JOIN fixtures ON rooms.id = fixtures.room_id)
         INNER JOIN marketing_materials ON fixtures.id = marketing_materials.fixture_id)
         WHERE offices.id = #{office["id"]};
         ")

    end

    # @temp.each do |k, v|
    #   puts k, "====="
    #   v.each { |v| puts v["cost"] }
    # end

    # @temp.each do |kk, vv|
    #   @temp[kk] = vv.inject(Hash.new(0)) {|value, i| value[i["type"]] = value["cost"]; value}
    # end




    @temp.each do |k, v, total_cost = 0|
      v.each do |material|

        if @data_cost[k][material["type"]]
          @data_cost[k][material["type"]] += material["cost"].to_i
        else
          @data_cost[k][material["type"]] = material["cost"].to_i
        end
        total_cost += material["cost"].to_i

      end
      @data_cost[k][:total_cost] = total_cost
    end
    @data_cost.each do |k, v|
      puts k, "====="
      v.each { |v| puts v }
    end



    template = File.read("./App/templates/materials_report.erb")
    content = ERB.new(template)
    [200, { "Content-Type" => "text/html" }, [content.result(binding)]]
  # [200, { "Content-Type" => "text/html" }, ["Good"]]
  end
end