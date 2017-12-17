require_relative('./../helper/dbhelper')
require_relative('./../models/artist')
require_relative('./../models/album')
require_relative('./../models/genre')


class StockAlbum

  attr_reader :sto_id
  attr_accessor :sto_qty_available, :sto_qty_min, :sto_qty_max, :sto_alb_id, :album

  def initialize(options)
    if(options != nil)
      @sto_id             = options['sto_id'] if options['sto_id']
      @sto_qty_available  = options['sto_qty_available']
      @sto_qty_min        = options['sto_qty_min']
      @sto_qty_max        = options['sto_qty_max']
      @sto_alb_id         = options['sto_alb_id']
      @album              = Album.new(options)
      @artist             = Artist.new(options)
      @genre              = Genre.new(options)
    else
      @sto_id             = 0
      @sto_qty_available  = 0
      @sto_qty_min        = 0
      @sto_qty_max        = 0
      @sto_alb_id         = 0
      @album              = Album.new(nil)
      @artist             = Artist.new(nil)
      @genre              = Genre.new(nil)
    end
  end



  def save()
    if(@sto_id)
      update()
    else
      insert()
    end
  end

  #Class methods
  def self.find_by_id(sto_id)
    query = "SELECT sto_id, sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id,
                    alb_id, alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id,
                    art_id, art_name, art_photo,
                    gen_id, gen_name
             FROM
             stocks INNER JOIN albums  on stocks.sto_alb_id = albums.alb_id
                    INNER JOIN genres  on albums.alb_gen_id = genres.gen_id
                    INNER JOIN artists on albums.alb_art_id = artists.art_id
             WHERE sto_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [sto_id], Stock)
  end

  def self.find_all(limit = 0)
    query = "SELECT sto_id, sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id,
                    alb_id, alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id,
                    art_id, art_name, art_photo,
                    gen_id, gen_name
             FROM
             stocks INNER JOIN albums  on stocks.sto_alb_id = albums.alb_id
                    INNER JOIN genres  on albums.alb_gen_id = genres.gen_id
                    INNER JOIN artists on albums.alb_art_id = artists.art_id"

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql_and_return_many_objects(query, [sto_id], Stock)
  end

  def self.find_with_filters(filters, limit = 0)
    query = "SELECT sto_id, sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id,
                    alb_id, alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id,
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

    return DbHelper.run_sql_and_return_many_objects(query, query_values, Stock)
  end



  def self.delete_by_id(sto_id)

  end

  def self.delete(sto_id)

  end




  private

  def insert()
    query = "INSERT INTO stocks (sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id)
                         VALUES ($1, $2, $3, $4) RETURNING sto_id"
     @sto_id = DbHelper.run_sql_return_first_row_column_value(query,
       [@sto_qty_available,
        @sto_qty_min,
        @sto_qty_max,
        @sto_alb_id], 'sto_id')
  end

  def update()
    query = "UPDATE stocks SET (sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id)
                         = ($1, $2, $3, $4) WHERE sto_id = $5"
    DbHelper.run_sql(query,
       [@sto_qty_available,
        @sto_qty_min,
        @sto_qty_max,
        @sto_alb_id,
        @sto_id])
  end


end
