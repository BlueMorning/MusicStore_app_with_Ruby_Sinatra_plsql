require_relative('./../helper/dbhelper')

class Genre

  attr_reader :gen_id, :gen_name
  attr_accessor :gen_name, :nav_to_albums, :nav_to_edit_form, :nav_to_delete

  def initialize(options)
    if(options != nil)
      @gen_id   = options['gen_id'] if options['gen_id']
      @gen_name = options['gen_name']
      @nav_to_albums      = NavStockAlbums::GET_WITH_FILTERS + "gen_id=#{@gen_id}"
      @nav_to_edit_form   = NavGenres.nav_get_edit_by_id(@gen_id)
      @nav_to_delete      = NavGenres.nav_post_delete_by_id(@gen_id)
    else
      @gen_id             = 0
      @gen_name           = ""
      @nav_to_albums      = ""
      @nav_to_edit_form   = ""
      @nav_to_delete      = ""
    end
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
  def self.link_create_new_genre()
    return NavGenres::GET_NEW
  end

  # Delete from the table genres the given object
  def self.delete(genre)
    query   = "DELETE FROM genres WHERE gen_id = $1"
    DbHelper.run_sql(query, [genre.gen_id])
    return genre
  end

  # Delete from the table genres the given gen_id
  def self.delete_by_id(gen_id)
    query   = "DELETE FROM genres WHERE gen_id = $1"
    DbHelper.run_sql(query, [gen_id])
  end

  # Find the genre on the given gen_id
  def self.find_by_id(gen_id)
    query   = "SELECT gen_id, gen_name FROM genres WHERE gen_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [gen_id], Genre)
  end

  # Find the genre on the given gen_id
  def self.find_by_id(gen_id)
    query   = "SELECT gen_id, gen_name FROM genres WHERE gen_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [gen_id], Genre)
  end

  # Find all the genres
  def self.find_all()
    query   = "SELECT gen_id, gen_name FROM genres"
    return DbHelper.run_sql_and_return_many_objects(query, [], Genre)
  end

  # Find all the genres
  def self.search_all_by_name(gen_name)
    query   = "SELECT gen_id, gen_name FROM genres WHERE lower(gen_name) LIKE lower($1) #{DbHelper::NB_ROWS_LIMIT}"
    return DbHelper.run_sql_and_return_many_objects(query, ["%#{gen_name}%"], Genre)
  end


  private

  # Insert the genre in the Genres table
  def insert()
    query   = "INSERT INTO genres (gen_name) VALUES ($1) RETURNING gen_id"
    @gen_id = DbHelper.run_sql_return_first_row_column_value(query, [@gen_name], 'gen_id')
  end

  # Update the genre in the Genres table
  def update()
    query   = "UPDATE genres SET gen_name = $1 WHERE gen_id = $2"
    DbHelper.run_sql(query, [@gen_name, @gen_id])
  end







end
