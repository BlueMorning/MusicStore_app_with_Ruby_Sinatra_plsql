require_relative('./../helper/dbhelper')
require_relative('./sale_item')


class SaleOrder

  attr_reader :slo_id
  attr_accessor :slo_cus_id, :slo_total_price, :slo_date, :sale_items, :sale_items_not_added, :slo_status, :customer

  STATUS_ONGOING = "O"
  STATUS_DONE    = "D"

  def initialize(options, init_sale_items = false, init_customer = false)
    if(options != nil)
      @slo_id           = options['slo_id'].to_i if options['slo_id']
      @slo_cus_id       = options['slo_cus_id'].to_i
      @slo_total_price  = options['slo_total_price'].to_i
      @slo_date         = options['slo_date']
      @slo_status       = options['slo_status']

      if(init_sale_items)
        @sale_items      = SaleItem.find_all_by_sale_order_id(@slo_id)
      else
        @sale_items      = []
      end

      if(init_customer)
        @customer = Customer.new(options)
      else
        @customer = nil
      end

    else
      @slo_id           = 0
      @slo_cus_id       = 0
      @slo_total_price  = 0
      @slo_date         = 0
      @sale_items       = []
      @slo_status       = ""
    end
  end


  def nb_items()
    query = "SELECT COUNT(sli_id) nb_items FROM sale_items WHERE sli_slo_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [@slo_id], 'nb_items').to_i
  end

  def total_quantity()
    query = "SELECT SUM(sli_qty) total_quantity FROM sale_items WHERE sli_slo_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [@slo_id], 'total_quantity').to_i
  end

  def can_be_delete()
    return slo_status == SaleOrder::STATUS_ONGOING
  end

  def can_be_modify()
    return slo_status == SaleOrder::STATUS_ONGOING
  end

  def set_list_of_sales_item_to_display(alb_title_or_art_name = "")

    if(@slo_id && @slo_id != 0)
      @sale_items = SaleItem.find_all_by_sale_order_id(@slo_id)
    end

    if(alb_title_or_art_name == nil || alb_title_or_art_name == "")
      albums_from_search = Album.find_all()
    else
      albums_from_search = Album.find_by_tittle_or_name(alb_title_or_art_name)
    end

    @sale_items_not_added = []
    albums_from_search.each do |album|

      if(@sale_items.select {|sale_item| sale_item.sli_alb_id == album.alb_id }.count() == 0)

        sale_item_not_added = SaleItem.new({
            "sli_id"          => 0,
            "sli_slo_id"      => @slo_id,
            "sli_qty"         => 0,
            "sli_unit_price"  => album.alb_price,
            "sli_alb_id"      => album.alb_id
          }
        )

        sale_item_not_added.album  = album
        sale_item_not_added.artist = album.artist
        sale_item_not_added.genre  = album.genre

        @sale_items_not_added.push(sale_item_not_added)

      end
    end
  end

  def update_order_with_items(sale_items_to_add)

    # Deleting of all the previous sale items of the sale order
    previous_sale_items = SaleItem.find_all_by_sale_order_id(@slo_id)
    previous_sale_items.each do |sale_item|
      SaleItem.delete_by_id(sale_item.sli_id)
    end

    # Adding of all the sale items whose qty set by the user > 0
    sale_items_to_add.each do |sale_item|
      sale_item.sli_slo_id      = @slo_id
      sale_item.sli_unit_price  = Album.find_by_id(sale_item.sli_alb_id).alb_price.to_i
      sale_item.sli_total_price = sale_item.sli_unit_price * sale_item.sli_qty.to_i
      sale_item.save()
    end

    update_total_price()

  end

  def update_total_price()
    query_1      = "SELECT SUM(sli_qty * sli_unit_price) total_amount FROM sale_items where sale_items.sli_slo_id = $1"
    total_amount = DbHelper.run_sql_return_first_row_column_value(query_1, [@slo_id], 'total_amount')

    total_amount = 0 if total_amount == nil

    query_2 = "UPDATE sale_orders SET slo_total_price = $1 WHERE sale_orders.slo_id = $2"
    DbHelper.run_sql(query_2, [total_amount, @slo_id])
  end

  def checkout()

    if(nb_items() > 0)
      query = "UPDATE sale_orders SET slo_status = $1 WHERE sale_orders.slo_id = $2 "
      DbHelper.run_sql(query, [SaleOrder::STATUS_DONE, @slo_id])

      saleItems = SaleItem.find_all_by_sale_order_id(@slo_id)
      saleItems.each do |sale_item|
        Album.update_qty_available(sale_item.sli_alb_id, -sale_item.sli_qty)
      end

    end
  end

  def slo_status_label()
    if   (slo_status == STATUS_ONGOING)
      return "OnGoing"
    elsif(slo_status == STATUS_DONE)
      return "Done"
    else
      return "Done"
    end
  end


  # Perform an insert or an update depending on the value of art_id
  def save()
    if(@slo_id) #if the row already exists
      update()
    else
      insert()
    end
  end

  #class methods
  # Delete from the table sales_orders the given object
  def self.delete(sale_order)
    query   = "DELETE FROM sale_orders WHERE slo_id = $1"
    DbHelper.run_sql(query, [sale_order.slo_id])
    return sale_order
  end

  # Delete from the table sales_orders the sale_order slo_id
  def self.delete_by_id(slo_id)

    sale_order = SaleOrder.find_by_id(slo_id)

    if(sale_order.slo_status == SaleOrder::STATUS_ONGOING)

      # Deleting of all the sale items of the sale order
      previous_sale_items = SaleItem.find_all_by_sale_order_id(slo_id)
      previous_sale_items.each do |sale_item|
        SaleItem.delete_by_id(sale_item.sli_id)
      end


      query   = "DELETE FROM sale_orders WHERE slo_id = $1"
      DbHelper.run_sql(query, [slo_id])
    end
  end

  # Find the sales_orders on the given slo_id
  def self.find_by_id(slo_id)
    query   = "SELECT slo_id, slo_cus_id, slo_total_price, slo_date, slo_status,
                      cus_id, cus_name
               FROM  sale_orders
               INNER JOIN customers on sale_orders.slo_cus_id = customers.cus_id
               WHERE slo_id = $1"
    return DbHelper.run_sql(query, [slo_id]).map {|sale_order| SaleOrder.new(sale_order, false, true)}[0]
  end

  # Find all the sale_orders
  def self.find_all()
    query   = "SELECT slo_id, slo_cus_id, slo_total_price, slo_date, slo_status,
               cus_id, cus_name
               FROM  sale_orders
               INNER JOIN customers on sale_orders.slo_cus_id = customers.cus_id"
    return DbHelper.run_sql(query, []).map {|sale_order| SaleOrder.new(sale_order, false, true)}
  end


  def self.query_orderby()
    orderby = {"slo_total_price_desc"  => "Total price + -> -",
               "slo_total_price_asc"   => "Total price - -> +"}
    return orderby
  end


  # Find all the sale orders with filters
  def self.find_with_filters(filters, limit = 0)
    query = "SELECT slo_id, slo_cus_id, slo_total_price, slo_date, slo_status,
                    cus_id, cus_name
             FROM  sale_orders
             INNER JOIN customers on sale_orders.slo_cus_id = customers.cus_id"

    if(filters.count() > 0)

      query_values = []

      query += " WHERE 1=1"

      if(filters.include?("slo_cus_id") &&
         filters["slo_cus_id"] != nil &&
         filters["slo_cus_id"] != 0)

        query_values.push(filters["slo_cus_id"].to_i)
        query += " AND slo_cus_id = $#{query_values.count()}"

      end

      if(filters.include?("slo_status") &&
         filters["slo_status"] != "" &&
         filters["slo_status"] != nil)

        query_values.push(filters["slo_status"])
        query += " AND slo_status = $#{query_values.count()}"
      end

      if(filters.include?("slo_id") &&
         filters["slo_id"] != 0 &&
         filters["slo_id"] != nil)

        query_values.push(filters["slo_id"].to_i)
        query += " AND slo_id = $#{query_values.count()}"
      end

      if(filters.include?("order_by") &&
         filters["order_by"] != "")

         query += " ORDER BY slo_total_price ASC"   if filters["order_by"] == "slo_total_price_asc"
         query += " ORDER BY slo_total_price DESC"  if filters["order_by"] == "slo_total_price_desc"
      end
    end

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql(query, query_values).map{|sale_order| SaleOrder.new(sale_order, false, true)}
  end

  private

  def insert()
    query = "INSERT INTO sale_orders (slo_cus_id, slo_total_price, slo_date, slo_status)
             VALUES ($1, $2, $3, $4) RETURNING slo_id"
    @slo_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@slo_cus_id, @slo_total_price, @slo_date, @slo_status], 'slo_id')
  end

  def update()
    query   = "UPDATE sale_orders SET (slo_cus_id, slo_total_price, slo_date, slo_status) =
                                      ($1, $2, $3, $4) WHERE slo_id = $5"
    DbHelper.run_sql(query, [@slo_cus_id, @slo_total_price, @slo_date,@slo_status, @slo_id])
  end

end
