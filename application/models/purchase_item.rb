require_relative('./../helper/dbhelper')
require('pry')




class PurchaseItem

  attr_reader :pri_id
  attr_accessor :pri_pro_id, :pri_qty, :pri_unit_price, :pri_total_price, :pri_alb_id, :album, :artist, :genre


  def initialize(options, init_album_artist_genre = false)
    if(options != nil)
      @pri_id           = options['pri_id'].to_i if options['pri_id']
      @pri_pro_id       = options['pri_pro_id'].to_i
      @pri_qty          = options['pri_qty'].to_i
      @pri_unit_price   = options['pri_unit_price'].to_i
      @pri_total_price  = @pri_qty * @pri_unit_price
      @pri_alb_id       = options['pri_alb_id'].to_i

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
      @pri_id           = 0
      @pri_pro_id       = 0
      @pri_qty          = 0
      @pri_unit_price   = 0
      @pri_total_price  = 0
      @pri_alb_id       = 0
      @album            = nil
      @artist           = nil
      @genre            = nil
    end
  end

  # Perform an insert or an update depending on the value of pri_id
  def save()
      if(@pri_id && @pri_id != 0)
        update()
      else
        insert()
      end
  end

  def previous_purchase_qty()
    query              = "SELECT pri_qty FROM purchase_items WHERE pri_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query,[@pri_id], "pli_qty")
  end


  # Class methods
  # Delete from the table purchase_items the given object
  def self.delete(purchase_item)
    query   = "DELETE FROM purchase_items WHERE pri_id = $1"
    DbHelper.run_sql(query, [purchase_item.pli_id])
    return purchase_item
  end

  # Delete from the table purchases the given pli_id
  def self.delete_by_id(pri_id)
    purchase_item    = self.find_by_id(pri_id)
    query        = "DELETE FROM purchase_items WHERE pri_id = $1"
    DbHelper.run_sql(query, [pri_id])
  end

  # Find the purchase_order on the given pri_id
  def self.find_by_id(pri_id)
    query   = "SELECT pri_id, pri_pro_id, pri_qty, pri_unit_price, pri_alb_id,
                      alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                      alb_qty_available, alb_qty_min, alb_qty_max,
                      art_id, art_name, art_photo,
                      gen_id, gen_name
               FROM purchase_items
               INNER JOIN albums  on purchase_items.pri_alb_id  = albums.alb_id
               INNER JOIN artists on albums.alb_art_id      = artists.art_id
               INNER JOIN genres  on albums.alb_gen_id      = genres.gen_id
               WHERE pri_id = $1"
    return DbHelper.run_sql(query, [pri_id]).map {|item| PurchaseItem.new(item, true)}[0]
  end

  # Find all the purchase_items from a purchase_order
  def self.find_all_by_purchase_order_id(pro_id)
    query   = "SELECT pri_id, pri_pro_id, pri_qty, pri_unit_price, pri_alb_id,
                      alb_id, alb_title, alb_price, alb_image, alb_art_id, alb_gen_id,
                      alb_qty_available, alb_qty_min, alb_qty_max,
                      art_id, art_name, art_photo,
                      gen_id, gen_name
               FROM purchase_items
               INNER JOIN albums  on purchase_items.pri_alb_id  = albums.alb_id
               INNER JOIN artists on albums.alb_art_id      = artists.art_id
               INNER JOIN genres  on albums.alb_gen_id      = genres.gen_id
               WHERE pri_pro_id = $1"
    return DbHelper.run_sql(query, [pro_id]).map {|item| PurchaseItem.new(item, true)}
  end


  private

  # Insert a new purchase_item
  def insert()
    query   = "INSERT INTO purchase_items (pri_qty, pri_unit_price, pri_alb_id, pri_pro_id)
               VALUES ($1, $2, $3, $4) RETURNING pri_id"
    @pri_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@pri_qty, @pri_unit_price, @pri_alb_id, @pri_pro_id],
      'pri_id').to_i
  end

  # Update an existing purchase_item
  def update()
    query   = "UPDATE purchase_items SET (pri_qty, pri_unit_price, pri_alb_id) = ($1, $2, $3) WHERE pri_id = $4"
    DbHelper.run_sql(query, [@pri_qty, @pri_unit_price, @pri_alb_id, @pri_id])
  end

end
