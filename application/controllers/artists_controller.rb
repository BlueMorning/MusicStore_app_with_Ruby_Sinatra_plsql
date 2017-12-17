require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/artist')
require_relative('./../helper/navigation')


# Display the stock of albums
get NavArtists::GET_INDEX do
  @art_name = params.include?('art_name') ? params['art_name'] : ""
  @artists  = Artist.find_all()
  erb(:"artists/index")
end

# Form to create a new album entry in the stock
get NavArtists::GET_NEW do


end

# Display the stocks of albums whose name match with the research
get NavArtists::GET_BY_NAME do
  @art_name = params['art_name']
  @artists  = Artist.search_all_by_name(@art_name)
  erb(:"artists/index")
end


# Form to edit an album
get NavArtists::GET_EDIT_BY_ID do


end

# Update the modifications of the album
post NavArtists::POST_UPDATE_BY_ID do


end

# Delete the album on its id
post NavArtists::POST_DELETE_BY_ID do


end