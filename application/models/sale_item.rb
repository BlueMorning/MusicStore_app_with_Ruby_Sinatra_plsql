require_relative('./../helper/dbhelper')
require('pry')




class SaleItem

  attr_reader :sli_id
  attr_accessor :sli_slo_id, :sli_qty, :sli_unit_price, :sli_total_price, :sli_alb_id, :qty_available, :album, :artist, :genre


  def initialize(options, init_album_artist_genre = false)
    if(options != nil)
      @sli_id           = options['sli_id'].to_i if options['sli_id']
      @sli_slo_id       = options['sli_slo_id'].to_i
      @sli_qty          = options['sli_qty'].to_i
      @sli_unit_price   = options['sli_unit_price'].to_i
      @sli_total_price  = @sli_qty * @sli_unit_price
      @sli_alb_id       = options['sli_alb_id'].to_i

      if(init_album_artist_genre)
        @album  = Album.new(options)
        @artist = Artist.new(options)
        @genre  = Genre.new(options)
      else
        @album  = nil
        @artist = nil
        @genre  = nil
      end

    else
      @sli_id           = 0
      @sli_slo_id       = 0
      @sli_qty          = 0
      @sli_unit_price   = 0
      @sli_total_price  = 0
      @sli_alb_id       = 0
      @album            = nil
      @artist           = nil
      @genre            = nil
    end
  end

  # Perform an insert or an update depending on the value of sli_id
  def save()

    qty_available  = Album.qty_available(@sli_alb_id)

    if(qty_available >= @sli_qty)

      if(@sli_id && @sli_id != 0)
        update()
      else
        insert()
      end
    end
  end

  def previous_sale_qty()
    query = "SELECT sli_qty FROM sale_items WHERE sli_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query,[@sli_id], "sal_qty")
  end


  # Class methods
  # Delete from the table sale_items the given object
  def self.delete(sale_item)
    query = "DELETE FROM sale_items WHERE sli_id = $1"
    DbHelper.run_sql(query, [sale.sal_id])
    return sale_item
  end

  # Delete from the table sales the given sal_id
  def self.delete_by_id(sli_id)
    query = "DELETE FROM sale_items WHERE sli_id = $1"
    DbHelper.run_sql(query, [sli_id])
  end

  # Find the sale_order on the given sli_id
  def self.find_by_id(sli_id)
    query   = "SELECT sli_id, sli_slo_id, sli_qty, sli_unit_price, sli_alb_id,
                      alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                      alb_qty_available, alb_qty_min, alb_qty_max,
                      art_id, art_name, art_photo,
                      gen_id, gen_name
               FROM sale_items
               INNER JOIN albums  on sale_items.sli_alb_id  = albums.alb_id
               INNER JOIN artists on albums.alb_art_id      = artists.art_id
               INNER JOIN genres  on albums.alb_gen_id      = genres.gen_id
               WHERE sli_id = $1"
    return DbHelper.run_sql(query, [sli_id]).map {|item| SaleItem.new(item, true)}[0]
  end

  # Find all the sale_items from a sale_order
  def self.find_all_by_sale_order_id(slo_id)
    query   = "SELECT sli_id, sli_slo_id, sli_qty, sli_unit_price, sli_alb_id,
                      alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                      alb_qty_available, alb_qty_min, alb_qty_max,
                      art_id, art_name, art_photo,
                      gen_id, gen_name
               FROM sale_items
               INNER JOIN albums  on sale_items.sli_alb_id  = albums.alb_id
               INNER JOIN artists on albums.alb_art_id      = artists.art_id
               INNER JOIN genres  on albums.alb_gen_id      = genres.gen_id
               WHERE sli_slo_id = $1"
    return DbHelper.run_sql(query, [slo_id]).map {|item| SaleItem.new(item, true)}
  end


  private

  # Insert a new sale_item
  def insert()
    query   = "INSERT INTO sale_items (sli_qty, sli_unit_price, sli_alb_id, sli_slo_id)
               VALUES ($1, $2, $3, $4) RETURNING sli_id"
    @sli_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@sli_qty, @sli_unit_price, @sli_alb_id, @sli_slo_id],
      'sli_id').to_i
  end

  # Update an existing sale_item
  def update()
    query   = "UPDATE sale_items SET (sli_qty, sli_unit_price, sli_alb_id) = ($1, $2, $3) WHERE sli_id = $4"
    DbHelper.run_sql(query, [@sli_qty, @sli_unit_price, @sli_alb_id, @sli_id])
  end

end
