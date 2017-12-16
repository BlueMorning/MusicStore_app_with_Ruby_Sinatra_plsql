require_relative('./../helper/dbhelper')

class Genre

  attr_reader :id, :name

  def initialize(options)
    @gen_id   = options['gen_id'] if options['gen_id']
    @gen_name = options['name']
  end


  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@gen_id) #if the row already exists
      update()
    else
      insert()
    end
  end



  # Class methods
  # Delete from the table genres the given object
  def self.delete(genre)
    query   = "DELETE FROM genres WHERE gen_id = $1"
    DbHelper.run_sql(query, [genre.gen_id])
    return genre
  end



  private

  # Insert the genre in the Genres table
  def insert()
    query   = "INSERT INTO genres (gen_name) VALUES ($1) RETURNING gen_id"
    @gen_id = DbHelper.run_sql(query, [@gen_name])
  end

  # Update the genre in the Genres table
  def update()
    query   = "UPDATE genres SET gen_name = $1 WHERE gen_id = $2"
    @gen_id = DbHelper.run_sql(query, [@gen_name, @gen_id])
  end







end
