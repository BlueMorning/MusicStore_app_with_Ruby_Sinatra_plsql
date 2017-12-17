require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/artist')
require_relative('./../helper/navigation')


# Display the stock of albums
get NavArtists::GET_ARTISTS_INDEX do

  p "YOU ARE HERE #{NavArtists::GET_ARTISTS_INDEX}"
end

# Form to create a new album entry in the stock
get NavArtists::GET_ARTISTS_NEW do


end

# Display the stocks of albums whose name match with the research
get NavArtists::GET_ARTISTS_BY_NAME do


end


# Form to edit an album
get NavArtists::GET_ARTISTS_EDIT_BY_ID do


end

# Update the modifications of the album
post NavArtists::POST_ARTISTS_UPDATE_BY_ID do


end

# Delete the album on its id
post NavArtists::POST_ARTISTS_DELETE_BY_ID do


end
