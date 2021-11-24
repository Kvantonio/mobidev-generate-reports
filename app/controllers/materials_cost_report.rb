# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class MaterialsCostReport
  def call(env)
    @data_materials = {}

    temp = {}

    materials =  DB.exec("SELECT marketing_materials.type, marketing_materials.cost, offices.title as office_title
         FROM (((( offices
         INNER JOIN zones ON offices.id = zones.office_id)
         INNER JOIN rooms ON zones.id = rooms.zone_id)
         INNER JOIN fixtures ON rooms.id = fixtures.room_id)
         INNER JOIN marketing_materials ON fixtures.id = marketing_materials.fixture_id)
         ")


    materials.each do |material|
      temp[material['office_title']] = [] if temp[material['office_title']] == nil
      @data_materials[material['office_title']] = {} if @data_materials[material['office_title']] == nil

      temp[material['office_title']] << material
    end

    @total_cost = []

    temp.each do |k, v, total_cost = 0|
      v.each do |material|
        if @data_materials[k][material['type']]
          @data_materials[k][material['type']] += material['cost'].to_i
        else
          @data_materials[k][material['type']] = material['cost'].to_i

        end
        total_cost += material['cost'].to_i
      end
      @total_cost << total_cost
    end

    template = File.read(File.join(File.dirname(__FILE__), '../templates/materials_report.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
