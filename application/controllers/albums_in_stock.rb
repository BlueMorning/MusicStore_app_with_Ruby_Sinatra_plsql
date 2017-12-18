require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/album_in_stock')
require_relative('./../models/artist')
require_relative('./../models/genre')
require_relative('./../helper/navigation')


get NavStockAlbums::GET_INDEX do

end

get NavStockAlbums::GET_WITH_FILTERS do

end

get NavStockAlbums::GET_NEW do
  @artists            = Artist.find_all()
  @genres             = Genre.find_all()
  @albumInStock       = AlbumInStock.new(nil)
  @form_title         = "Add a new Album in the Stock"
  @form_action        = NavStockAlbums::POST_NEW
  @form_submit_label  = "Save"
  erb(:"/albums_in_stock/new_or_edit")
end

# Create a new entry in the stock from the form
post NavStockAlbums::GET_INDEX do
  @albumInStock = AlbumInStock.new(params)
  @albumInStock.save()
  redirect(:"#{NavStockAlbums::GET_INDEX}")
end

get NavStockAlbums::GET_EDIT_BY_ID do

end

post NavStockAlbums::POST_UPDATE_BY_ID do

end

post NavStockAlbums::POST_DELETE_BY_ID do

end
