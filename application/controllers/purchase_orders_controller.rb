require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/purchase_order')
require_relative('./../models/supplier')
require_relative('./../helper/navigation')



# Display the purchases which match with the research filters
get NavPurchaseOrders::GET_INDEX do
  @filters = {}
  params.include?("pro_id")           ? @filters["pro_id"]     = params["pro_id"].to_i                : @filters["pro_id"]     = 0
  params.include?("pro_sup_id")       ? @filters["pro_sup_id"] = params["pro_sup_id"].to_i            : @filters["pro_sup_id"] = 0
  params.include?("pro_status")       ? @filters["pro_status"] = params["pro_status"]                 : @filters["pro_status"] = ""
  params.include?("order_by")         ? @filters["order_by"]   = params["order_by"]                   : @filters["order_by"]   = ""

  @suppliers   = Supplier.find_all()
  @purchase_orders = PurchaseOrder.find_with_filters(@filters)
  erb(:"purchase_orders/index")
end


# Display the purchases which match with the research filters
get NavPurchaseOrders::GET_WITH_FILTERS do
  @filters = {}
  params.include?("pro_id")           ? @filters["pro_id"]     = params["pro_id"].to_i                : @filters["pro_id"]     = 0
  params.include?("pro_sup_id")       ? @filters["pro_sup_id"] = params["pro_sup_id"].to_i            : @filters["pro_sup_id"] = 0
  params.include?("pro_status")       ? @filters["pro_status"] = params["pro_status"]                 : @filters["pro_status"] = ""
  params.include?("order_by")         ? @filters["order_by"]   = params["order_by"]                   : @filters["order_by"]   = ""

  @suppliers   = Supplier.find_all()
  @purchase_orders = PurchaseOrder.find_with_filters(@filters)
  erb(:"purchase_orders/index")
end

get NavPurchaseOrders::GET_VIEW do
  @purchase_order     = PurchaseOrder.find_by_id(params['pro_id'].to_i, true)
  erb(:"purchase_orders/show")
end

# Form to create a new purchase
get NavPurchaseOrders::GET_NEW do
  @purchase_order     = PurchaseOrder.new(nil)
  @album_search       = params.include?('album_search') ? params['album_search'] : ""
  @purchase_order.set_list_of_purchases_item_to_display(@album_search)
  @suppliers          = Supplier.find_all()
  @form_title         = "New Purchase Order"
  @form_submit_label  = "Ckeckout"
  @form_search_action = NavPurchaseOrders::GET_NEW
  erb(:"purchase_orders/new_or_edit")
end

# Form to edit a Purchase Order
get NavPurchaseOrders::GET_EDIT_BY_ID do
  @purchase_order     = PurchaseOrder.find_by_id(params['pro_id'].to_i)
  @album_search       = params.include?('album_search') ? params['album_search'] : ""
  @purchase_order.set_list_of_purchases_item_to_display(@album_search)
  @suppliers          = Supplier.find_all()
  @form_title         = "Modify Purchase Order"
  @form_submit_label  = "Checkout"
  @form_search_action = NavPurchaseOrders.nav_get_edit_by_id(@purchase_order.pro_id)
  erb(:"purchase_orders/new_or_edit")
end


# # Create a new purchase from the form
# post NavPurchaseOrders::GET_INDEX do
#   @purchase_order = PurchaseOrder.new(params)
#   @purchase_order.save()
#   redirect(:"#{NavPurchaseOrders::GET_INDEX}")
# end

# Collect all the purchase items whose quantity > 0 and add them to the Purchase Order
post NavPurchaseOrders::POST_ADD_ITEMS do

  purchase_item_from_params = params.select {|key, value| key.match(/qty_alb_id_*/)}
  purchase_items_to_add     = []

  purchase_item_from_params.each do |key, value|
    if(value.to_i) > 0

      purchase_item                 = PurchaseItem.new(nil)
      purchase_item.pri_alb_id      = key.sub("qty_alb_id_", "").to_i
      purchase_item.pri_unit_price  = params["price_alb_id_#{purchase_item.pri_alb_id}"].to_i
      purchase_item.pri_qty         = params["qty_alb_id_#{purchase_item.pri_alb_id}"].to_i

      purchase_items_to_add.push(purchase_item)
    end
  end


  purchase_order_id = params['pro_id'].to_i
  customer_id       = params["pro_sup_id"].to_i

  if(purchase_order_id == 0)
    @purchase_order = PurchaseOrder.new({"pro_sup_id"       => customer_id,
                                         "pro_total_price"  => 0,
                                         "pro_date"         => Time.now,
                                         "pro_status"       => PurchaseOrder::STATUS_ONGOING})
  else
    @purchase_order            = PurchaseOrder.find_by_id(purchase_order_id)
    @purchase_order.pro_sup_id = customer_id
  end

  @purchase_order.save()
  @purchase_order.update_order_with_items(purchase_items_to_add)

  redirect(:"#{NavPurchaseOrders.nav_get_edit_by_id(@purchase_order.pro_id)}")
end

post NavPurchaseOrders::POST_CHECKOUT_BY_ID do
  @purchase_order = PurchaseOrder.find_by_id(params['pro_id'].to_i)
  @purchase_order.checkout()
  redirect(:"#{NavPurchaseOrders::GET_INDEX}")
end


# Delete the purchase on its id
post NavPurchaseOrders::POST_DELETE_BY_ID do
  PurchaseOrder.delete_by_id(params['pro_id'])
  redirect(:"#{NavPurchaseOrders::GET_INDEX}")
end
