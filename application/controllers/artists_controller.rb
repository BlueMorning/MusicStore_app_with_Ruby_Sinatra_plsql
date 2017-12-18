require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/artist')
require_relative('./../helper/navigation')


# Display the list of artist
get NavArtists::GET_INDEX do
  @filters             = {}
  @filters["art_name"] = ""
  @artists             = Artist.find_all()
  erb(:"artists/index")
end

# Form to create a artist
get NavArtists::GET_NEW do
  @artist             = Artist.new(nil)
  @form_title         = "New Artist"
  @form_action        = NavArtists::POST_NEW
  @form_submit_label  = "Save"
  erb(:"artists/new_or_edit")
end

# Create a new artist from the form
post NavArtists::GET_INDEX do
  @artist = Artist.new(params)
  @artist.save()
  redirect(:"#{NavArtists::GET_INDEX}")
end

# Display the artists whose name match with the research
get NavArtists::GET_WITH_FILTERS do
  @filters = {}
  params.include?("art_name") ? @filters["art_name"] = params["art_name"] : @filters["art_name"] = ""
  params.include?("strict")   ? @filters["strict"]   = params["strict"]   : @filters["strict"]   = false
  @artists  = Artist.search_all_by_name(@filters['art_name'], @filters['strict'])
  erb(:"artists/index")
end


# Form to edit an artist
get NavArtists::GET_EDIT_BY_ID do
  @artist             = Artist.find_by_id(params['art_id'])
  @form_title         = "Modify Artist"
  @form_action        = NavArtists.nav_post_update_by_id(@artist.art_id)
  @form_submit_label  = "Update"
  erb(:"artists/new_or_edit")
end

# Update the modifications on the artist
post NavArtists::POST_UPDATE_BY_ID do
  @artist = Artist.new(params)
  @artist.save()
  redirect(:"#{NavArtists::GET_INDEX}")
end

# Delete the album on its id
post NavArtists::POST_DELETE_BY_ID do
  Artist.delete_by_id(params['art_id'])
  redirect(:"#{NavArtists::GET_INDEX}")
end
