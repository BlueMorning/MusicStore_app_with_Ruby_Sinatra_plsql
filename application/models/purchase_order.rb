require_relative('./../helper/dbhelper')
require_relative('./purchase_item')


class PurchaseOrder

  attr_reader :pro_id
  attr_accessor :pro_sup_id, :pro_total_price, :pro_date, :purchase_items, :purchase_items_not_added, :pro_status, :supplier

  STATUS_ONGOING = "O"
  STATUS_DONE    = "D"

  def initialize(options, init_purchase_items = false, init_supplier = false)
    if(options != nil)
      @pro_id           = options['pro_id'].to_i if options['pro_id']
      @pro_sup_id       = options['pro_sup_id'].to_i
      @pro_total_price  = options['pro_total_price'].to_i
      @pro_date         = options['pro_date']
      @pro_status       = options['pro_status']

      if(init_purchase_items)
        @purchase_items      = PurchaseItem.find_all_by_purchase_order_id(@pro_id)
      else
        @purchase_items      = []
      end

      if(init_supplier)
        @supplier = Supplier.new(options)
      else
        @supplier = nil
      end

    else
      @pro_id           = 0
      @pro_sup_id       = 0
      @pro_total_price  = 0
      @pro_date         = 0
      @purchase_items   = []
      @pro_status       = ""
    end
  end


  def nb_items()
    query = "SELECT COUNT(pri_id) nb_items FROM purchase_items WHERE pri_pro_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [@pro_id], 'nb_items').to_i
  end

  def total_quantity()
    query = "SELECT SUM(pri_qty) total_quantity FROM purchase_items WHERE pri_pro_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [@pro_id], 'total_quantity').to_i
  end

  def can_be_delete()
    return pro_status == PurchaseOrder::STATUS_ONGOING
  end

  def can_be_modify()
    return pro_status == PurchaseOrder::STATUS_ONGOING
  end

  def set_list_of_purchases_item_to_display(alb_title_or_art_name = "")

    if(@pro_id && @pro_id != 0)
      @purchase_items = PurchaseItem.find_all_by_purchase_order_id(@pro_id)
    end

    if(alb_title_or_art_name == nil || alb_title_or_art_name == "")
      albums_from_search = Album.find_all()
    else
      albums_from_search = Album.find_by_tittle_or_name(alb_title_or_art_name)
    end

    @purchase_items_not_added = []
    albums_from_search.each do |album|

      if(@purchase_items.select {|purchase_item| purchase_item.pri_alb_id == album.alb_id }.count() == 0)

        purchase_item_not_added = PurchaseItem.new({
            "pri_id"          => 0,
            "pri_pro_id"      => @pro_id,
            "pri_qty"         => 0,
            "pri_unit_price"  => 0,
            "pri_alb_id"      => album.alb_id
          }
        )

        purchase_item_not_added.album  = album
        purchase_item_not_added.artist = album.artist
        purchase_item_not_added.genre  = album.genre

        @purchase_items_not_added.push(purchase_item_not_added)

      end
    end
  end

  def update_order_with_items(purchase_items_to_add)

    # Deleting of all the previous purchase items of the purchase order
    previous_purchase_items = PurchaseItem.find_all_by_purchase_order_id(@pro_id)
    previous_purchase_items.each do |purchase_item|
      PurchaseItem.delete_by_id(purchase_item.pri_id)
    end

    # Adding of all the purchase items whose qty set by the user > 0
    purchase_items_to_add.each do |purchase_item|
      purchase_item.pri_pro_id      = @pro_id
      purchase_item.pri_total_price = purchase_item.pri_unit_price * purchase_item.pri_qty.to_i
      purchase_item.save()
    end

    update_total_price()

  end

  def update_total_price()
    query_1      = "SELECT SUM(pri_qty * pri_unit_price) total_amount FROM purchase_items where purchase_items.pri_pro_id = $1"
    total_amount = DbHelper.run_sql_return_first_row_column_value(query_1, [@pro_id], 'total_amount')

    total_amount = 0 if total_amount == nil

    query_2 = "UPDATE purchase_orders SET pro_total_price = $1 WHERE purchase_orders.pro_id = $2"
    DbHelper.run_sql(query_2, [total_amount, @pro_id])
  end

  def checkout()

    if(nb_items() > 0)
      query = "UPDATE purchase_orders SET pro_status = $1 WHERE purchase_orders.pro_id = $2 "
      DbHelper.run_sql(query, [PurchaseOrder::STATUS_DONE, @pro_id])

      purchaseItems = PurchaseItem.find_all_by_purchase_order_id(@pro_id)
      purchaseItems.each do |purchase_item|
        Album.update_qty_available(purchase_item.pri_alb_id, purchase_item.pri_qty)
      end

    end
  end

  def pro_status_label()
    if   (pro_status == STATUS_ONGOING)
      return "OnGoing"
    elsif(pro_status == STATUS_DONE)
      return "Done"
    else
      return "Done"
    end
  end


  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@pro_id) #if the row already exists
      update()
    else
      insert()
    end
  end

  #class methods
  # Delete from the table purchase_orders the given object
  def self.delete(purchase_order)
    query   = "DELETE FROM purchase_orders WHERE pro_id = $1"
    DbHelper.run_sql(query, [purchase_order.pro_id])
    return purchase_order
  end

  # Delete from the table purchase_orders the purchase_order pro_id
  def self.delete_by_id(pro_id)

    purchase_order = PurchaseOrder.find_by_id(pro_id)

    if(purchase_order.pro_status == PurchaseOrder::STATUS_ONGOING)

      # Deleting of all the purchase items of the purchase order
      previous_purchase_items = PurchaseItem.find_all_by_purchase_order_id(pro_id)
      previous_purchase_items.each do |purchase_item|
        PurchaseItem.delete_by_id(purchase_item.pri_id)
      end


      query   = "DELETE FROM purchase_orders WHERE pro_id = $1"
      DbHelper.run_sql(query, [pro_id])
    end
  end

  # Find the purchase_orders on the given pro_id
  def self.find_by_id(pro_id)
    query   = "SELECT pro_id, pro_sup_id, pro_total_price, pro_date, pro_status,
                      sup_id, sup_name
               FROM  purchase_orders
               INNER JOIN suppliers on purchase_orders.pro_sup_id = suppliers.sup_id
               WHERE pro_id = $1"
    return DbHelper.run_sql(query, [pro_id]).map {|purchase_order| PurchaseOrder.new(purchase_order, false, true)}[0]
  end

  # Find all the purchase_orders
  def self.find_all()
    query   = "SELECT pro_id, pro_sup_id, pro_total_price, pro_date, pro_status,
               sup_id, sup_name
               FROM  purchase_orders
               INNER JOIN suppliers on purchase_orders.pro_sup_id = suppliers.sup_id"
    return DbHelper.run_sql(query, []).map {|purchase_order| PurchaseOrder.new(purchase_order, false, true)}
  end


  def self.query_orderby()
    orderby = {"pro_total_price_desc"  => "Total price + -> -",
               "pro_total_price_asc"   => "Total price - -> +"}
    return orderby
  end


  # Find all the purchase orders with filters
  def self.find_with_filters(filters, limit = 0)
    query = "SELECT pro_id, pro_sup_id, pro_total_price, pro_date, pro_status,
                    sup_id, sup_name
             FROM  purchase_orders
             INNER JOIN suppliers on purchase_orders.pro_sup_id = suppliers.sup_id"

    if(filters.count() > 0)

      query_values = []

      query += " WHERE 1=1"

      if(filters.include?("pro_sup_id") &&
         filters["pro_sup_id"] != nil &&
         filters["pro_sup_id"] != 0)

        query_values.push(filters["pro_sup_id"].to_i)
        query += " AND pro_sup_id = $#{query_values.count()}"

      end

      if(filters.include?("pro_status") &&
         filters["pro_status"] != "" &&
         filters["pro_status"] != nil)

        query_values.push(filters["pro_status"])
        query += " AND pro_status = $#{query_values.count()}"
      end

      if(filters.include?("pro_id") &&
         filters["pro_id"] != 0 &&
         filters["pro_id"] != nil)

        query_values.push(filters["pro_id"].to_i)
        query += " AND pro_id = $#{query_values.count()}"
      end

      if(filters.include?("order_by") &&
         filters["order_by"] != "")

         query += " ORDER BY pro_total_price ASC"   if filters["order_by"] == "pro_total_price_asc"
         query += " ORDER BY pro_total_price DESC"  if filters["order_by"] == "pro_total_price_desc"
      end
    end

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql(query, query_values).map{|purchase_order| PurchaseOrder.new(purchase_order, false, true)}
  end

  private

  def insert()
    query = "INSERT INTO purchase_orders (pro_sup_id, pro_total_price, pro_date, pro_status)
             VALUES ($1, $2, $3, $4) RETURNING pro_id"
    @pro_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@pro_sup_id, @pro_total_price, @pro_date, @pro_status], 'pro_id')
  end

  def update()
    query   = "UPDATE purchase_orders SET (pro_sup_id, pro_total_price, pro_date, pro_status) =
                                      ($1, $2, $3, $4) WHERE pro_id = $5"
    DbHelper.run_sql(query, [@pro_sup_id, @pro_total_price, @pro_date, @pro_status, @pro_id])
  end

end
