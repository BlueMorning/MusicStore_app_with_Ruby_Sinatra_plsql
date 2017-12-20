require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./../models/album')
require_relative('./../models/artist')
require_relative('./../models/genre')
require_relative('./../helper/navigation')


get NavAlbums::GET_INDEX do
  @albums  = Album.find_all()
  @genres  = Genre.find_all()
  @filters = {}
  params.include?("alb_title")   ? @filters["alb_title"]    = params["alb_title"]         : @filters["alb_title"]   = ""
  params.include?("art_name")    ? @filters["art_name"]     = params["art_name"]          : @filters["art_name"]    = ""
  params.include?("alb_gen_id")  ? @filters["alb_gen_id"]   = params["alb_gen_id"].to_i   : @filters["alb_gen_id"]  = 0
  params.include?("stock_level") ? @filters["stock_level"]  = params["stock_level"]       : @filters["stock_level"] = ""
  erb(:"/albums/index")
end


get NavAlbums::GET_WITH_FILTERS do
  @albums  = Album.find_with_filters(params)
  @genres  = Genre.find_all()
  @filters = {}
  params.include?("alb_title")   ? @filters["alb_title"]    = params["alb_title"]         : @filters["alb_title"]   = ""
  params.include?("art_name")    ? @filters["art_name"]     = params["art_name"]          : @filters["art_name"]    = ""
  params.include?("alb_gen_id")  ? @filters["alb_gen_id"]   = params["alb_gen_id"].to_i   : @filters["alb_gen_id"]  = 0
  params.include?("stock_level") ? @filters["stock_level"]  = params["stock_level"]       : @filters["stock_level"] = ""
  erb(:"/albums/index")
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
