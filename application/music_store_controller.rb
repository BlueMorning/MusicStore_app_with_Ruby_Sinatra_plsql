require( 'sinatra' )
require( 'sinatra/contrib/all' )
require_relative('controllers/artists_controller')
require_relative('controllers/genres_controller')
require_relative('controllers/albums_controller')
require_relative('controllers/customers_controller')
require_relative('controllers/suppliers_controller')
require_relative('controllers/sale_orders_controller')
require_relative('controllers/purchase_orders_controller')
require_relative('helper/navigation')

get '/' do
  redirect(:"#{NavAlbums::GET_INDEX}")
end
