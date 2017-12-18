require_relative('./../helper/dbhelper')


class Album

  attr_reader   :alb_id
  attr_accessor :alb_title, :alb_price, :alb_image, :alb_image_path, :alb_art_id, :alb_gen_id,
                :alb_qty_available, :alb_qty_min, :alb_qty_max


  def initialize(options)
    if(options != nil)
      @alb_id               = options['alb_id'] if options['alb_id']
      @alb_title            = options['alb_title']
      @alb_price            = options['alb_price']
      @alb_image            = @alb_title.downcase.sub(" ","")
      @alb_image_path       = NavMusicStore::DATA_IMAGES_PATH + @alb_image + ".jpg"
      @alb_art_id           = options['alb_art_id']
      @alb_gen_id           = options['alb_gen_id']
      @alb_qty_available    = options['alb_qty_available']
      @alb_qty_min          = options['alb_qty_min']
      @alb_qty_max          = options['alb_qty_max']

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

  def self.find_with_filters(filters, limit = 0)
    query = "SELECT alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                    alb_qty_available, alb_qty_min, alb_qty_max,
                    art_id, art_name, art_photo,
                    gen_id, gen_name
             FROM
             stocks INNER JOIN albums  on stocks.sto_alb_id = albums.alb_id
                    INNER JOIN genres  on albums.alb_gen_id = genres.gen_id
                    INNER JOIN artists on albums.alb_art_id = artists.art_id"

    if(filters.count() > 0)

      query_values = []

      query += " WHERE 1=1"

      if(filters.include?("alb_title"))
        query += " AND lower(alb_title) LIKE lower($1)"
        query_values.push("%#{["alb_title"]}%")
      end

      if(filters.include?("art_name"))
        query += " AND lower(art_name) LIKE lower($2)"
        query_values.push("%#{["art_name"]}%")
      end

      if(filters.include?("gen_name"))
        query += " AND lower(gen_name) LIKE lower($3)"
        query_values.push("%#{["gen_name"]}%")
      end

      if(filters.include?("stock_level"))
        if    filters["stock_level"] == "low"
            query += " AND sto_qty_available <= sto_qty_min"
        elsif filters["stock_level"] == "medium"
            query += " AND sto_qty_available > sto_qty_min AND sto_qty_available < sto_qty_max"
        elsif filters["stock_level"] == "high"
            query += " AND sto_qty_available >= sto_qty_max"
        end
      end
    end

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql_and_return_many_objects(query, query_values, Album)
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
