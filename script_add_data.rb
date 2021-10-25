require 'pg'

module InsertData

  def pars all_data

    db = PG::Connection.open(dbname: 'Task_one', password: "12345678")

    db.prepare('office', 'INSERT INTO offices (title, address, city, state, phone, LOB, type)
                                values ($1, $2, $3,$4,$5,$6,$7) returning id')
    db.prepare('zone', 'INSERT INTO zones (office_id, type)
                                values ($1, $2) returning id')
    db.prepare('room', 'INSERT INTO rooms (zone_id, name, area, max_people)
                                values ($1, $2, $3,$4) returning id')
    db.prepare('fixture', 'INSERT INTO fixtures (room_id, name, type)
                                values ($1, $2, $3) returning id')
    db.prepare('marketing_material', 'INSERT INTO marketing_materials (fixture_id, name, cost, type)
                                values ($1, $2, $3,$4) returning id')

    if all_data
      all_data.each do |data|
        office = get_or_create_office db, [
          data["Office"],
          data['Office address'],
          data['Office city'],
          data['Office State'],
          data['Office phone'].to_i,
          data['Office lob'],
          data['Office type']
        ]

        zone = get_or_create_zone db, [office, data['Zone']]

        room = get_or_create_room db, [
          zone,
          data['Room'],
          data['Room area'],
          data['Room max people']
        ]

        fixture = get_or_create_fixture db, [
          room,
          data['Fixture'],
          data['Fixture Type']
        ]

        get_or_create_material db, [
          fixture,
          data['Marketing material'],
          data['Marketing material cost'],
          data['Marketing material type']
        ]


      end
    end

  end

  def get_or_create_office(db_connection, search_params)
    res = db_connection.exec_params("SELECT * FROM offices WHERE
                                    title = $1 AND address = $2 AND city = $3 AND state = $4
                                     AND phone = $5", search_params[0..4])
    unless res.first
      return db_connection.exec_prepared('office', search_params)[0]["id"]
    end
    res[0]['id']
  end

  def get_or_create_zone(db_connection, search_params)
    res = db_connection.exec_params("SELECT * FROM zones WHERE
                                    office_id = $1 AND type = $2", search_params)
    unless res.first
      return db_connection.exec_prepared('zone', search_params)[0]["id"]
    end
    res[0]['id']
  end

  def get_or_create_room(db_connection, search_params)
    res = db_connection.exec_params("SELECT * FROM rooms WHERE
                                    zone_id = $1 AND name = $2", search_params[0..1])
    unless res.first
      return db_connection.exec_prepared('room', search_params)[0]["id"]
    end
    res[0]['id']
  end

  def get_or_create_fixture(db_connection, search_params)
    res = db_connection.exec_params("SELECT * FROM fixtures WHERE
                                    room_id = $1 AND name = $2 AND type = $3",
                                    search_params[0..2])
    unless res.first
      return db_connection.exec_prepared('fixture', search_params)[0]["id"]
    end
    res[0]['id']
  end

  def get_or_create_material(db_connection, search_params)
    res = db_connection.exec_params("SELECT * FROM marketing_materials WHERE
                                    fixture_id = $1", search_params[0...1])
    unless res.first
      return db_connection.exec_prepared('marketing_material', search_params)[0]["id"]
    end
    res[0]['id']
  end

end

