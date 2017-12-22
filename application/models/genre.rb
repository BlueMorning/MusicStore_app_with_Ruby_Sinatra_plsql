require_relative('./../helper/dbhelper')

class Genre

  attr_reader :gen_id, :gen_name
  attr_accessor :gen_name, :nav_to_albums, :nav_to_edit_form, :nav_to_delete

  def initialize(options)
    if(options != nil)
      @gen_id   = options['gen_id'].to_i if options['gen_id']
      @gen_name = options['gen_name']
    else
      @gen_id             = 0
      @gen_name           = ""
    end
  end

  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@gen_id && @gen_id != 0) #if the row already exists
      update()
      return true
    else
      if(! Genre.check_if_name_exists(@gen_name))
        insert()
        return true
      else
        return false
      end

    end
  end



  # Class methods

  def self.check_if_name_exists(gen_name)
    query = "SELECT COUNT(genres.gen_id) nb_genres FROM genres WHERE lower(genres.gen_name) = lower($1)"
    return DbHelper.run_sql_return_first_row_column_value(query, [gen_name], 'nb_genres').to_i > 0;
  end

  def self.can_be_deleted(gen_id)
    query = "SELECT COUNT(albums.alb_id) nb_references from albums WHERE albums.alb_gen_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [gen_id], 'nb_references').to_i == 0;
  end

  # Delete from the table genres the given gen_id
  def self.delete_by_id(gen_id)
    if(Genre.can_be_deleted(gen_id))
      query   = "DELETE FROM genres WHERE gen_id = $1"
      DbHelper.run_sql(query, [gen_id])
      return true
    else
      return false
    end
  end

  # Find the genre on the given gen_id
  def self.find_by_id(gen_id)
    query   = "SELECT gen_id, gen_name FROM genres WHERE gen_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [gen_id], Genre)
  end

  # Find all the genres
  def self.find_all()
    query   = "SELECT gen_id, gen_name FROM genres ORDER BY gen_name"
    return DbHelper.run_sql_and_return_many_objects(query, [], Genre)
  end

  # Find all the genres
  def self.search_all_by_name(gen_name, strict = false)
    if (!strict)
      query   = "SELECT gen_id, gen_name FROM genres WHERE lower(gen_name) LIKE lower($1) ORDER BY gen_name"
      return DbHelper.run_sql_and_return_many_objects(query, ["%#{gen_name}%"], Genre)
    else
      query   = "SELECT gen_id, gen_name FROM genres WHERE gen_name = $1 ORDER BY gen_name"
      return DbHelper.run_sql_and_return_many_objects(query, ["#{gen_name}"], Genre)
    end

  end


  private

  # Insert the genre in the Genres table
  def insert()
    query   = "INSERT INTO genres (gen_name) VALUES ($1) RETURNING gen_id"
    @gen_id = DbHelper.run_sql_return_first_row_column_value(query, [@gen_name], 'gen_id').to_i
  end

  # Update the genre in the Genres table
  def update()
    query   = "UPDATE genres SET gen_name = $1 WHERE gen_id = $2"
    DbHelper.run_sql(query, [@gen_name, @gen_id])
  end







end
