require_relative('./../helper/dbhelper')


class Album

  attr_reader   :alb_id, :artist, :genre
  attr_accessor :alb_title, :alb_price, :alb_image, :alb_image_path, :alb_art_id, :alb_gen_id,
                :alb_qty_available, :alb_qty_min, :alb_qty_max, :nav_to_edit_form, :nav_to_delete


  def initialize(options, init_artist_genres = false)
    if(options != nil)
      @alb_id               = options['alb_id'].to_i if options['alb_id']
      @alb_title            = options['alb_title']
      @alb_price            = options['alb_price'].to_i
      @alb_image            = @alb_title.downcase.sub(" ","")
      @alb_image_path       = NavMusicStore::DATA_IMAGES_PATH + @alb_image + ".jpg"
      @alb_art_id           = options['alb_art_id'].to_i
      @alb_gen_id           = options['alb_gen_id'].to_i
      @alb_qty_available    = options['alb_qty_available'].to_i
      @alb_qty_min          = options['alb_qty_min'].to_i
      @alb_qty_max          = options['alb_qty_max'].to_i

      if(init_artist_genres)
        @artist = Artist.new(options)
        @genre  = Genre.new(options)
      else
        @artist = nil
        @genre  = nil
      end

    else
      @alb_id               = 0
      @alb_title            = ""
      @alb_price            = 0
      @alb_image            = ""
      @alb_image_path       = ""
      @alb_art_id           = 0
      @alb_gen_id           = 0
      @alb_qty_available    = 0
      @alb_qty_min          = 0
      @alb_qty_max          = 0
      @artist               = nil
      @genre                = nil
    end
  end

  # Perform an insert or an update depending on the value of ald_id
  def save()
    if(@alb_id)
      update()
    else
      insert()
    end
  end

  def nb_sales()
    query = "SELECT SUM(sli_qty) total_qty FROM sale_items WHERE sli_alb_id = $1"
    result = DbHelper.run_sql_return_first_row_column_value(query, [@alb_id], "total_qty")
    return result != nil ? result.to_i : 0
  end

  def total_amount()
    query = "SELECT SUM(sli_unit_price*sli_qty) total_amount FROM sale_items WHERE sli_alb_id = $1"
    result = DbHelper.run_sql_return_first_row_column_value(query, [@alb_id], "total_amount")
    return result != nil ? result.to_i : 0
  end

  def stock_level()
    if(   @alb_qty_available <= @alb_qty_min)
      return Album.all_stock_level[0]
    elsif(@alb_qty_available >= @alb_qty_max)
      return Album.all_stock_level[2]
    else
      return Album.all_stock_level[1]
    end
  end

  #Class method


  # Delete from the table albums the given object and return the object
  def self.delete(album)
    query   = "DELETE FROM albums WHERE alb_id = $1"
    DbHelper.run_sql(query, [album.alb_id])
    return album
  end

  # Delete from the table albums the given alb_id
  def self.delete_by_id(alb_id)
    query   = "DELETE FROM albums WHERE alb_id = $1"
    DbHelper.run_sql(query, [alb_id])
  end

  # Find the album on the given alb_id
  def self.find_by_id(alb_id)
    query   = "SELECT alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
               alb_qty_available, alb_qty_min, alb_qty_max FROM albums
               WHERE alb_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [alb_id], Album)
  end

  def self.find_all(limit = 0)
    query = "SELECT alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                    alb_qty_available, alb_qty_min, alb_qty_max,
                    art_id, art_name, art_photo,
                    gen_id, gen_name
             FROM
             albums
             INNER JOIN genres  on albums.alb_gen_id = genres.gen_id
             INNER JOIN artists on albums.alb_art_id = artists.art_id"

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql(query).map{|album| Album.new(album, true)}
  end

  def self.find_by_tittle_or_name(alb_title_or_art_name = "")
    query = "SELECT   alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                      alb_qty_available, alb_qty_min, alb_qty_max,
                      art_id, art_name, art_photo,
                      gen_id, gen_name
             FROM albums
             INNER JOIN      artists    on albums.alb_art_id = artists.art_id
             INNER JOIN      genres     on albums.alb_gen_id = genres.gen_id
             WHERE lower(albums.alb_title) LIKE lower($1) or lower(artists.art_name) LIKE lower($1)"
     return DbHelper.run_sql(query, ["%#{alb_title_or_art_name}%"]).map {|album| Album.new(album, true)}
  end

  def self.find_with_filters(filters, limit = 0)
    query = "SELECT alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                    alb_qty_available, alb_qty_min, alb_qty_max,
                    art_id, art_name, art_photo,
                    gen_id, gen_name
             FROM
             albums INNER JOIN genres  on albums.alb_gen_id = genres.gen_id
                    INNER JOIN artists on albums.alb_art_id = artists.art_id"

    if(filters.count() > 0)

      query_values = []

      query += " WHERE 1=1"

      if(filters.include?("alb_title") &&
         filters["alb_title"] != "")

        query_values.push("%#{filters["alb_title"]}%")
        query += " AND lower(alb_title) LIKE lower($#{query_values.count()})"

      end

      if(filters.include?("art_name") &&
         filters["art_name"] != "")

         query_values.push("%#{filters["art_name"]}%")
         query += " AND lower(art_name) LIKE lower($#{query_values.count()})"

      end

      if(filters.include?("alb_gen_id") &&
         filters["alb_gen_id"] != "" &&
         filters["alb_gen_id"] != 0 )

        query_values.push(filters["alb_gen_id"])
        query += " AND alb_gen_id = $#{query_values.count()}"

      end

      if(filters.include?("stock_level") &&
         filters["stock_level"] != "" &&
         filters["stock_level"] != 0)

        if    filters["stock_level"] == "low"
            query += " AND alb_qty_available <= alb_qty_min"
        elsif filters["stock_level"] == "medium"
            query += " AND alb_qty_available > alb_qty_min AND alb_qty_available < alb_qty_max"
        elsif filters["stock_level"] == "high"
            query += " AND alb_qty_available >= alb_qty_max"
        end

      end
    end

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql(query, query_values).map{|album| Album.new(album, true)}
  end


  def self.all_stock_level()
    return ["low", "medium", "high"]
  end

  def self.update_qty_available(alb_id, qty_variation)
    query = "UPDATE albums SET alb_qty_available = (alb_qty_available + $1) WHERE alb_id = $2"
    DbHelper.run_sql(query, [qty_variation, alb_id])
  end

  def self.qty_available(alb_id)
    query = "SELECT alb_qty_available FROM albums WHERE alb_id = $1"
    DbHelper.run_sql_return_first_row_column_value(query, [alb_id], "alb_qty_available").to_i
  end


  private

  def insert()
    query   = "INSERT INTO albums (alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                                   alb_qty_available, alb_qty_min, alb_qty_max)
               VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING alb_id"
    @alb_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@alb_title,
       @alb_price,
       @alb_image,
       @alb_art_id,
       @alb_gen_id,
       @alb_qty_available,
       @alb_qty_min,
       @alb_qty_max], 'alb_id');
  end

  def update()
    query   = "UPDATE albums SET (alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                                  alb_qty_available, alb_qty_min, alb_qty_max) =
                                 ($1, $2, $3, $4, $5, $6, $7, $8) WHERE alb_id = $9"
    @alb_id = DbHelper.run_sql(query,
      [@alb_title,
       @alb_price,
       @alb_image,
       @alb_art_id,
       @alb_gen_id,
       @alb_qty_available,
       @alb_qty_min,
       @alb_qty_max,
       @alb_id]);
  end

end
