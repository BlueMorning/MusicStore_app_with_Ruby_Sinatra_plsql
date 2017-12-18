require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/genre')
require_relative('./../helper/navigation')


# Display the list of genres
get NavGenres::GET_INDEX do
  @filters = {}
  params.include?("gen_name") ? @filters["gen_name"] = params["gen_name"] : @filters["gen_name"] = ""
  params.include?("strict")   ? @filters["strict"]   = params["strict"]   : @filters["strict"]   = false
  @genres   = Genre.find_all()
  erb(:"genres/index")
end

# Form to create a new genre
get NavGenres::GET_NEW do
  @genre              = Genre.new(nil)
  @form_title         = "New Genre"
  @form_action        = NavGenres::POST_NEW
  @form_submit_label  = "Save"
  erb(:"genres/new_or_edit")
end

# Create a new genre from the form
post NavGenres::GET_INDEX do
  @genre = Genre.new(params)
  @genre.save()
  redirect(:"#{NavGenres::GET_INDEX}")
end

# Display the genres whose name match with the research
get NavGenres::GET_WITH_FILTERS do
  @filters = {}
  params.include?("gen_name") ? @filters["gen_name"] = params["gen_name"] : @filters["gen_name"] = ""
  params.include?("strict")   ? @filters["strict"]   = params["strict"]   : @filters["strict"]   = false
  @genres  = Genre.search_all_by_name(@filters['gen_name'], @filters['strict'])
  erb(:"genres/index")
end


# Form to edit an genre
get NavGenres::GET_EDIT_BY_ID do
  @genre              = Genre.find_by_id(params['gen_id'])
  @form_title         = "Modify Genre"
  @form_action        = NavGenres.nav_post_update_by_id(@genre.gen_id)
  @form_submit_label  = "Update"
  erb(:"genres/new_or_edit")
end

# Update the modifications on the genre
post NavGenres::POST_UPDATE_BY_ID do
  @genre = Genre.new(params)
  @genre.save()
  redirect(:"#{NavGenres::GET_INDEX}")
end

# Delete the genre on its id
post NavGenres::POST_DELETE_BY_ID do
  Genre.delete_by_id(params['gen_id'])
  redirect(:"#{NavGenres::GET_INDEX}")
end
