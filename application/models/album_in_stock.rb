require_relative('./../helper/dbhelper')
require_relative('./../models/artist')
require_relative('./../models/album')
require_relative('./../models/genre')
require_relative('./../models/stock')


class AlbumInStock

  attr_accessor :stock, :album, :artist, :genre

  def initialize(options, init_artist_and_genre = false)
    if(options != nil)
      @album = Album.new(options)
      @stock = Stock.new(options)
    else
      @album = Album.new(nil)
      @stock = Stock.new(nil)
    end

    if(init_artist_and_genre)
      initialize_album_artist_genre(options)
    end

  end

  def initialize_artist_and_genre(options)
    if(options != nil)
      @artist             = Artist.new(options)
      @genre              = Genre.new(options)
    else
      @artist             = Artist.new(nil)
      @genre              = Genre.new(nil)
    end
  end



  def save()
    @album.save()
    @stock.sto_alb_id = @album.alb_id
    @stock.save()
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
end
