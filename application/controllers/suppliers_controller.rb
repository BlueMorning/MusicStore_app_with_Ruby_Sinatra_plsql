require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/supplier')
require_relative('./../helper/navigation')


# Display the list of suppliers
get NavSuppliers::GET_INDEX do
  @filters             = {}
  @filters["sup_name"] = ""
  @suppliers           = Supplier.find_all()
  erb(:"suppliers/index")
end

# Form to create a supplier
get NavSuppliers::GET_NEW do
  @supplier           = Supplier.new(nil)
  @form_title         = "New Supplier"
  @form_action        = NavSuppliers::POST_NEW
  @form_submit_label  = "Save"
  erb(:"suppliers/new_or_edit")
end

# Create a new supplier from the form
post NavSuppliers::GET_INDEX do
  @supplier = Supplier.new(params)
  @supplier.save()
  redirect(:"#{NavSuppliers::GET_INDEX}")
end

# Display the suppliers whose name match with the research
get NavSuppliers::GET_WITH_FILTERS do
  @filters = {}
  params.include?("sup_name") ? @filters["sup_name"] = params["sup_name"] : @filters["sup_name"] = ""
  params.include?("strict")   ? @filters["strict"]   = params["strict"]   : @filters["strict"]   = false
  @suppliers  = Supplier.search_all_by_name(@filters['sup_name'], @filters['strict'])
  erb(:"suppliers/index")
end


# Form to edit a supplier
get NavSuppliers::GET_EDIT_BY_ID do
  @supplier           = Supplier.find_by_id(params['sup_id'])
  @form_title         = "Modify Supplier"
  @form_action        = NavSuppliers.nav_post_update_by_id(@supplier.sup_id)
  @form_submit_label  = "Update"
  erb(:"suppliers/new_or_edit")
end

# Update the modifications on the supplier
post NavSuppliers::POST_UPDATE_BY_ID do
  @supplier = Supplier.new(params)
  @supplier.save()
  redirect(:"#{NavSuppliers::GET_INDEX}")
end

# Delete the supplier on its id
post NavSuppliers::POST_DELETE_BY_ID do
  Supplier.delete_by_id(params['sup_id'])
  redirect(:"#{NavSuppliers::GET_INDEX}")
end
