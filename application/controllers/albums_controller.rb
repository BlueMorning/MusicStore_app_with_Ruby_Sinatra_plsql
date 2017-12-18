require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/album')
require_relative('./../models/artist')
require_relative('./../models/genre')
require_relative('./../helper/navigation')


get NavAlbums::GET_INDEX do
  @albums = Album.find_all()
  erb(:"/albums/index")
end

get NavAlbums::GET_WITH_FILTERS do

end

get NavAlbums::GET_NEW do
  @artists            = Artist.find_all()
  @genres             = Genre.find_all()
  @album              = Album.new(nil)
  @form_title         = "Add a new Album in the Stock"
  @form_action        = NavAlbums::POST_NEW
  @form_submit_label  = "Save"
  erb(:"/albums/new_or_edit")
end

# Create a new entry in the stock from the form
post NavAlbums::GET_INDEX do
  @album = Album.new(params)
  @album.save()
  redirect(:"#{NavAlbums::GET_INDEX}")
end

get NavAlbums::GET_EDIT_BY_ID do
  @artists            = Artist.find_all()
  @genres             = Genre.find_all()
  @album              = Album.find_by_id(params['alb_id'])
  @form_title         = "Modify the Stock Album Entry"
  @form_action        = NavAlbums.nav_post_update_by_id(params['alb_id'])
  @form_submit_label  = "Save"
  erb(:"/albums/new_or_edit")
end

post NavAlbums::POST_UPDATE_BY_ID do
  @album = Album.new(params)
  @album.save()
  redirect(:"#{NavAlbums::GET_INDEX}")
end

post NavAlbums::POST_DELETE_BY_ID do
  Album.delete_by_id(params['alb_id'])
  redirect(:"#{NavAlbums::GET_INDEX}")
end
