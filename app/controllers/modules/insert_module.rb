# frozen_string_literal: true

require 'pg'

module InsertModule
  def pars_and_add(all_data)
    all_data&.each do |data|
      office = get_or_create DB, 'offices', {
        title: data['Office'],
        address: data['Office address'],
        city: data['Office city'],
        state: data['Office State'],
        phone: data['Office phone'].to_i,
        lob: data['Office lob'],
        type: data['Office type']
      }

      zone = get_or_create DB, 'zones', {
        office_id: office,
        type: data['Zone']
      }

      room = get_or_create DB, 'rooms', {
        zone_id: zone,
        name: data['Room'],
        area: data['Room area'],
        max_people: data['Room max people']
      }

      fixture = get_or_create DB, 'fixtures', {
        room_id: room,
        name: data['Fixture'],
        type: data['Fixture Type']
      }

      get_or_create DB, 'marketing_materials', {
        fixture_id: fixture,
        name: data['Marketing material'],
        cost: data['Marketing material cost'],
        type: data['Marketing material type']
      }
    end
  end

  def get_or_create(conn, table, s_params)
    title_columns = []
    mutable = []

    s_params.each_with_index { |(key, _value), i| title_columns << "#{key} = $#{i + 1}" }
    s_params.length.times { |i| mutable << "$#{i + 1}" }

    title_columns = title_columns.join(' AND ')
    mutable = mutable.join(', ')
    titles = s_params.keys.join(', ')

    res = conn.exec_params("SELECT * FROM #{table} WHERE #{title_columns}",
                           s_params.values)
    unless res.first
      return conn.exec_params("INSERT INTO #{table} (#{titles})
                                values (#{mutable}) returning id", s_params.values)[0]['id']
    end
    res[0]['id']
  end
end
