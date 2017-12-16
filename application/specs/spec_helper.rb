require_relative('./../helper/dbhelper')
require_relative('./../models/artist')


puts "TEST DbHelper.run_sql and DbHelper.map_to_object NO query parameters"
query       = "SELECT * FROM artists"
artist_rows = DbHelper.run_sql(query)
artists     = DbHelper.map_to_object(artist_rows, Artist)
p artists.count()
p artists.first().class()


puts "TEST DbHelper.run_sql and DbHelper.map_to_object WITH query parameter"
query       = "SELECT * FROM artists WHERE lower(art_name) LIKE lower($1)"
artist_rows = DbHelper.run_sql(query, ['%E%'])
artists     = DbHelper.map_to_object(artist_rows, Artist)
p artists.count()
p artists.first().class()

puts "TEST DbHelper.run_sql_and_return_many_objects NO query parameter"
query       = "SELECT * FROM artists"
artists     = DbHelper.run_sql_and_return_many_objects(query, [], Artist)
p artists.count()
p artists.first().class()

puts "TEST DbHelper.run_sql_and_return_one_object NO query parameter"
query       = "SELECT * FROM artists LIMIT 1"
artist      = DbHelper.run_sql_and_return_one_object(query, [], Artist)
p artist.class()
