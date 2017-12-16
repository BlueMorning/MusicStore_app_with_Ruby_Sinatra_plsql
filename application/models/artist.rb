


class Artist

  def initialize(options)
    @art_id   = options['art_id'] if options['art_id']
    @art_name = options['name']
  end


  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@art_id) #if the row already exists
      update()
    else
      insert()
    end
  end



  private

  # Insert the artist in the Artist table
  def insert()
    query   = "INSERT INTO artists (art_name) VALUES ($1) RETURNING art_id"
    @art_id = DbHelper.run_sql(query, [@art_name])
  end

  # Update the artist in the Artist table
  def update()
    query   = "UPDATE artists SET art_name = $1 WHERE art_id = $2"
    @art_id = DbHelper.run_sql(query, [@art_name, @art_id])
  end


end
