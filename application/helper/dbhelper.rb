require('pg')


# Class which provides genereric class methods to query the database
class DbHelper

  # sql: query to execute.
  # params : array of the parameters used in the query.
  # return the result of the query in an array.
  def self.run_sql(sql, params = [])
    begin
      db_connection = PG.connect({dbname: "music_store", host: "localhost"})
      db_connection.prepare("query", sql)

      result        = db_connection.exec_prepared("query", params)
    ensure
      db_connection.close() if db_connection != nil
    end

    return result
  end

  # sql: query to execute.
  # params : array of the parameters used in the query.
  # return the value of the given column of the first row
  def self.run_sql_return_first_row_column_value(sql, params = [], column_name)
    begin
      db_connection = PG.connect({dbname: "music_store", host: "localhost"})
      db_connection.prepare("query", sql)

      result        = db_connection.exec_prepared("query", params)
    ensure
      db_connection.close() if db_connection != nil
    end

    return result[0][column_name]
  end

  # array_of_hashes to turn into objects.
  # classname : name of the class that the hashes have to be turned into.
  # return an array of classname objects
  def self.map_to_object(array_of_hashes, classname)
    return nil if(array_of_hashes == nil || classname == nil)
    return array_of_hashes.map {|hash| classname.new(hash)}
  end

  # Executes the sql query and turns the result into an array of objects of the given classname
  def self.run_sql_and_return_many_objects(sql, params, classname)
    return self.map_to_object(self.run_sql(sql, params), classname)
  end

  # Executes the sql query and turns the result into one object of the given classname
  def self.run_sql_and_return_one_object(sql, params, classname)
    return self.map_to_object(self.run_sql(sql, params), classname)[0]
  end


end
