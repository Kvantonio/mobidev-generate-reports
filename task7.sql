SELECT row_to_json(office)
FROM (
    SELECT zones.type,  (
             SELECT array_to_json(array_agg(row_to_json(z)))
             FROM (
                      SELECT rooms.name, (
                          SELECT array_to_json(array_agg(row_to_json(f)))
                          FROM (
                                   SELECT fixtures.type, fixtures.name,
                                          mm.type m_type, mm.name m_name
                                   FROM fixtures INNER JOIN marketing_materials mm on fixtures.id = mm.fixture_id
                                   WHERE fixtures.room_id = rooms.id
                               ) f
                      ) as fixtures
                      FROM rooms
                      WHERE rooms.zone_id = zones.id
                  ) z
         ) as zones
         FROM zones
         WHERE zones.office_id = 1
) office;