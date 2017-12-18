require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/customer')
require_relative('./../helper/navigation')


# Display the list of customers
get NavCustomers::GET_INDEX do
  @filters             = {}
  @filters["cus_name"] = ""
  @customers           = Customer.find_all()
  erb(:"customers/index")
end

# Form to create a customer
get NavCustomers::GET_NEW do
  @customer           = Customer.new(nil)
  @form_title         = "New Customer"
  @form_action        = NavCustomers::POST_NEW
  @form_submit_label  = "Save"
  erb(:"customers/new_or_edit")
end

# Create a new customer from the form
post NavCustomers::GET_INDEX do
  @customer = Customer.new(params)
  @customer.save()
  redirect(:"#{NavCustomers::GET_INDEX}")
end

# Display the customers whose name match with the research
get NavCustomers::GET_WITH_FILTERS do
  @filters = {}
  params.include?("cus_name") ? @filters["cus_name"] = params["cus_name"] : @filters["cus_name"] = ""
  params.include?("strict")   ? @filters["strict"]   = params["strict"]   : @filters["strict"]   = false
  @customers  = Customer.search_all_by_name(@filters['cus_name'], @filters['strict'])
  erb(:"customers/index")
end


# Form to edit a customer
get NavCustomers::GET_EDIT_BY_ID do
  @customer           = Customer.find_by_id(params['cus_id'])
  @form_title         = "Modify Customer"
  @form_action        = NavCustomers.nav_post_update_by_id(@customer.cus_id)
  @form_submit_label  = "Update"
  erb(:"customers/new_or_edit")
end

# Update the modifications on the customer
post NavCustomers::POST_UPDATE_BY_ID do
  @customer = Customer.new(params)
  @customer.save()
  redirect(:"#{NavCustomers::GET_INDEX}")
end

# Delete the customer on its id
post NavCustomers::POST_DELETE_BY_ID do
  Customer.delete_by_id(params['cus_id'])
  redirect(:"#{NavCustomers::GET_INDEX}")
end
