require_relative('./../helper/dbhelper')


class Artist

  attr_reader :art_id, :art_name
  attr_accessor :art_name

  def initialize(options)
    @art_id   = options['art_id'] if options['art_id']
    @art_name = options['art_name']
  end


  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@art_id) #if the row already exists
      update()
    else
      insert()
    end
  end



  # Class methods
  # Delete from the table artists the given object and return the object
  def self.delete(artist)
    query   = "DELETE FROM artists WHERE art_id = $1"
    DbHelper.run_sql(query, [artist.art_id])
    return artist
  end

  # Delete from the table artists the given art_id
  def self.delete_by_id(art_id)
    query   = "DELETE FROM artists WHERE art_id = $1"
    DbHelper.run_sql(query, [art_id])
  end

  # Find the artist on the given art_id
  def self.find_by_id(art_id)
    query   = "SELECT art_id, art_name FROM artists WHERE art_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [art_id], Artist)
  end

  # Find all the artists whose name matches
  def self.find_all_by_name(art_name)
    query   = "SELECT art_id, art_name FROM artists WHERE lower(art_name) = $1 #{DBHelper.NB_ROWS_LIMIT}"
    return DbHelper.run_sql_and_return_one_object(query, ["%#{art_name}%"], Artist)
  end



  private

  # Insert the artist in the Artist table
  def insert()
    query   = "INSERT INTO artists (art_name) VALUES ($1) RETURNING art_id"
    @art_id = DbHelper.run_sql_return_first_row_column_value(query, [@art_name], 'art_id');
  end

  # Update the artist in the Artist table
  def update()
    query   = "UPDATE artists SET art_name = $1 WHERE art_id = $2"
    DbHelper.run_sql(query, [@art_name, @art_id])
  end


end
