require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/sale_order')
require_relative('./../models/customer')
require_relative('./../helper/navigation')


# Display the sales which match with the research filters
get NavSaleOrders::GET_INDEX do
  @filters = {}
  params.include?("slo_id")       ? @filters["slo_id"]     = params["slo_id"].to_i      : @filters["slo_id"]     = 0
  params.include?("slo_cus_id")   ? @filters["slo_cus_id"] = params["slo_cus_id"].to_i  : @filters["slo_cus_id"] = 0
  params.include?("slo_status")   ? @filters["slo_status"] = params["slo_status"]       : @filters["slo_status"] = ""
  params.include?("order_by")     ? @filters["order_by"]   = params["order_by"]         : @filters["order_by"]   = ""

  @customers   = Customer.find_all()
  @sale_orders = SaleOrder.find_with_filters(@filters)
  erb(:"sale_orders/index")
end


# Display the sales which match with the research filters
get NavSaleOrders::GET_WITH_FILTERS do
  @filters = {}
  params.include?("slo_id")       ? @filters["slo_id"]     = params["slo_id"].to_i      : @filters["slo_id"]     = 0
  params.include?("slo_cus_id")   ? @filters["slo_cus_id"] = params["slo_cus_id"].to_i  : @filters["slo_cus_id"] = 0
  params.include?("slo_status")   ? @filters["slo_status"] = params["slo_status"]       : @filters["slo_status"] = ""
  params.include?("order_by")     ? @filters["order_by"]   = params["order_by"]         : @filters["order_by"]   = ""

  @customers   = Customer.find_all()
  @sale_orders = SaleOrder.find_with_filters(@filters)
  erb(:"sale_orders/index")
end


# Form to create a new sale
get NavSaleOrders::GET_NEW do
  @sale_order         = SaleOrder.new(nil)
  album_search        = params.include?('album_search') ? params['album_search'] : ""
  @sale_order.set_list_of_sales_item_to_display(album_search)
  @customers          = Customer.find_all()
  @form_title         = "New Sale Order"
  @form_submit_label  = "Checkout"
  @form_search_action = NavSaleOrders::GET_NEW
  erb(:"sale_orders/new_or_edit")
end

# Form to edit a sale order
get NavSaleOrders::GET_EDIT_BY_ID do
  @sale_order         = SaleOrder.find_by_id(params['slo_id'].to_i)
  album_search        = params.include?('album_search') ? params['album_search'] : ""
  @sale_order.set_list_of_sales_item_to_display(album_search)
  @customers          = Customer.find_all()
  @form_title         = "Modify Sale Order"
  @form_submit_label  = "Checkout"
  @form_search_action = NavSaleOrders.nav_get_edit_by_id(@sale_order.slo_id)
  erb(:"sale_orders/new_or_edit")
end


# # Create a new sale from the form
# post NavSaleOrders::GET_INDEX do
#   @sale_order = SaleOrder.new(params)
#   @sale_order.save()
#   redirect(:"#{NavSaleOrders::GET_INDEX}")
# end

# Collect all the sale items whose quantity > 0 and add them to the sale order
post NavSaleOrders::POST_ADD_ITEMS do

  sale_item_from_params = params.select {|key, value| key.match(/qty_alb_id_*/)}
  sale_items_to_add     = []
  sale_item_from_params.each do |key, value|
    if(value.to_i) > 0
      sale_item            = SaleItem.new(nil)
      sale_item.sli_alb_id = key.sub("qty_alb_id_", "").to_i
      sale_item.sli_qty    = params["qty_alb_id_#{sale_item.sli_alb_id}"].to_i
      sale_items_to_add.push(sale_item)
    end
  end


  sale_order_id = params['slo_id'].to_i
  customer_id   = params["slo_cus_id"].to_i


  if(sale_order_id == 0)
    @sale_order = SaleOrder.new({"slo_cus_id"       => customer_id,
                                 "slo_total_price"  => 0,
                                 "slo_date"         => Time.now,
                                 "slo_status"       => SaleOrder::STATUS_ONGOING})
  else
    @sale_order = SaleOrder.find_by_id(sale_order_id)
    @sale_order.slo_cus_id = customer_id
  end

  @sale_order.save()
  @sale_order.update_order_with_items(sale_items_to_add)

  redirect(:"#{NavSaleOrders.nav_get_edit_by_id(@sale_order.slo_id)}")
end

post NavSaleOrders::POST_CHECKOUT_BY_ID do
  @sale_order = SaleOrder.find_by_id(params['slo_id'].to_i)
  @sale_order.checkout()
  redirect(:"#{NavSaleOrders::GET_INDEX}")
end


# Delete the sale on its id
post NavSaleOrders::POST_DELETE_BY_ID do
  SaleOrder.delete_by_id(params['slo_id'])
  redirect(:"#{NavSaleOrders::GET_INDEX}")
end
