class NavMusicStore

  ROOT             = "/mstore"
  DATA_IMAGES_PATH = "/data_images/"

  def self.all_front_pages()
    pages = []

    pages.push({"link_path" => NavGenres::GET_INDEX,              "link_name" =>   "Genres"})             #Genres
    pages.push({"link_path" => NavArtists::GET_INDEX,             "link_name" =>   "Artists"})            #Artists
    pages.push({"link_path" => NavAlbums::GET_WITH_FILTERS,       "link_name" =>   "Albums"})             #Albums
    pages.push({"link_path" => NavCustomers::GET_INDEX,           "link_name" =>   "Customers"})          #Customers
    pages.push({"link_path" => NavSuppliers::GET_INDEX,           "link_name" =>   "Suppliers"})          #Suppliers
    pages.push({"link_path" => NavSaleOrders::GET_INDEX,          "link_name" =>   "Sale Orders"})        #Sale Orders
    pages.push({"link_path" => NavPurchaseOrders::GET_INDEX,      "link_name" =>   "Purchase Orders"})    #Purchase Orders

    return pages
  end


end


class NavArtists

  GET_INDEX         = NavMusicStore::ROOT+"/artists"
  GET_NEW           = NavMusicStore::ROOT+"/artists/new"
  POST_NEW          = NavMusicStore::ROOT+"/artists"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/artists/search/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/artists/:art_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id/delete'

  def self.nav_get_with_art_name(art_name, strict = false)
    return NavMusicStore::ROOT+"/artists/search/?art_name=#{art_name}&strict=#{strict}"
  end

  def self.nav_get_edit_by_id(art_id)
    return NavMusicStore::ROOT+"/artists/#{art_id}/edit"
  end

  def self.nav_post_update_by_id(art_id)
    return NavMusicStore::ROOT+"/artists/#{art_id}"
  end

  def self.nav_post_delete_by_id(art_id)
    return NavMusicStore::ROOT+"/artists/#{art_id}/delete"
  end
end


class NavGenres

  GET_INDEX         = NavMusicStore::ROOT+"/genres"
  GET_NEW           = NavMusicStore::ROOT+"/genres/new"
  POST_NEW          = NavMusicStore::ROOT+"/genres"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/genres/search/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/genres/:gen_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/genres/:gen_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/genres/:gen_id/delete'

  def self.nav_get_with_gen_name(gen_name, strict = false)
    return NavMusicStore::ROOT+"/genres/search/?gen_name=#{gen_name}&strict=#{strict}"
  end

  def self.nav_get_edit_by_id(gen_id)
    return NavMusicStore::ROOT+"/genres/#{gen_id}/edit"
  end

  def self.nav_post_update_by_id(gen_id)
    return NavMusicStore::ROOT+"/genres/#{gen_id}"
  end

  def self.nav_post_delete_by_id(gen_id)
    return NavMusicStore::ROOT+"/genres/#{gen_id}/delete"
  end
end


class NavAlbums

  GET_INDEX         = NavMusicStore::ROOT+"/albums"
  GET_NEW           = NavMusicStore::ROOT+"/albums/new"
  POST_NEW          = NavMusicStore::ROOT+"/albums"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/albums/search/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/albums/:alb_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/albums/:alb_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/albums/:alb_id/delete'

  def self.nav_get_with_art_name(art_name)
    return NavMusicStore::ROOT+"/albums/search/?art_name=#{art_name}"
  end

  def self.nav_get_with_gen_id(alb_gen_id)
    return NavMusicStore::ROOT+"/albums/search/?alb_gen_id=#{alb_gen_id}"
  end

  def self.nav_get_edit_by_id(alb_id)
    return NavMusicStore::ROOT+"/albums/#{alb_id}/edit"
  end

  def self.nav_post_update_by_id(alb_id)
    return NavMusicStore::ROOT+"/albums/#{alb_id}"
  end

  def self.nav_post_delete_by_id(alb_id)
    return NavMusicStore::ROOT+"/albums/#{alb_id}/delete"
  end
end

class NavCustomers

  GET_INDEX         = NavMusicStore::ROOT+"/customers"
  GET_NEW           = NavMusicStore::ROOT+"/customers/new"
  POST_NEW          = NavMusicStore::ROOT+"/customers"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/customers/search/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/customers/:cus_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/customers/:cus_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/customers/:cus_id/delete'

  def self.nav_get_with_art_name(cus_name, strict = false)
    return NavMusicStore::ROOT+"/customers/search/?cus_name=#{cus_name}&strict=#{strict}"
  end

  def self.nav_get_edit_by_id(cus_id)
    return NavMusicStore::ROOT+"/customers/#{cus_id}/edit"
  end

  def self.nav_post_update_by_id(cus_id)
    return NavMusicStore::ROOT+"/customers/#{cus_id}"
  end

  def self.nav_post_delete_by_id(cus_id)
    return NavMusicStore::ROOT+"/customers/#{cus_id}/delete"
  end
end

class NavSuppliers

  GET_INDEX         = NavMusicStore::ROOT+"/suppliers"
  GET_NEW           = NavMusicStore::ROOT+"/suppliers/new"
  POST_NEW          = NavMusicStore::ROOT+"/suppliers"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/suppliers/search/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/suppliers/:sup_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/suppliers/:sup_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/suppliers/:sup_id/delete'

  def self.nav_get_with_art_name(sup_name, strict = false)
    return NavMusicStore::ROOT+"/suppliers/search/?sup_name=#{sup_name}&strict=#{strict}"
  end

  def self.nav_get_edit_by_id(sup_id)
    return NavMusicStore::ROOT+"/suppliers/#{sup_id}/edit"
  end

  def self.nav_post_update_by_id(sup_id)
    return NavMusicStore::ROOT+"/suppliers/#{sup_id}"
  end

  def self.nav_post_delete_by_id(sup_id)
    return NavMusicStore::ROOT+"/suppliers/#{sup_id}/delete"
  end
end


class NavSaleOrders

  GET_INDEX             = NavMusicStore::ROOT+"/sale_orders"
  GET_VIEW              = NavMusicStore::ROOT+"/sale_orders/:slo_id/view"
  GET_NEW               = NavMusicStore::ROOT+"/sale_orders/new"
  POST_NEW              = NavMusicStore::ROOT+"/sale_orders"
  GET_WITH_FILTERS      = NavMusicStore::ROOT+"/sale_orders/search/?"
  GET_EDIT_BY_ID        = NavMusicStore::ROOT+"/sale_orders/:slo_id/edit"
  POST_UPDATE_BY_ID     = NavMusicStore::ROOT+'/sale_orders/:slo_id'
  POST_DELETE_BY_ID     = NavMusicStore::ROOT+'/sale_orders/:slo_id/delete'
  POST_CHECKOUT_BY_ID   = NavMusicStore::ROOT+'/sale_orders/:slo_id/checkout'
  POST_ADD_ITEMS        = NavMusicStore::ROOT+'/sale_orders/:slo_id/add_items'


  def self.nav_get_view_by_id(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}/view"
  end

  def self.nav_get_with_slo_cus_id(slo_cus_id, strict = false)
    return NavMusicStore::ROOT+"/sale_orders/search/?slo_cus_id=#{slo_cus_id}"
  end

  def self.nav_get_edit_by_id(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}/edit"
  end

  def self.nav_post_update_by_id(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}"
  end

  def self.nav_post_delete_by_id(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}/delete"
  end

  def self.nav_post_checkout_by_id(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}/checkout"
  end

  def self.nav_post_add_items(slo_id)
    return NavMusicStore::ROOT+"/sale_orders/#{slo_id}/add_items"
  end


end

class NavPurchaseOrders

  GET_INDEX             = NavMusicStore::ROOT+"/purchase_orders"
  GET_VIEW              = NavMusicStore::ROOT+"/purchase_orders/:pro_id/view"
  GET_NEW               = NavMusicStore::ROOT+"/purchase_orders/new"
  POST_NEW              = NavMusicStore::ROOT+"/purchase_orders"
  GET_WITH_FILTERS      = NavMusicStore::ROOT+"/purchase_orders/search/?"
  GET_EDIT_BY_ID        = NavMusicStore::ROOT+"/purchase_orders/:pro_id/edit"
  POST_UPDATE_BY_ID     = NavMusicStore::ROOT+'/purchase_orders/:pro_id'
  POST_DELETE_BY_ID     = NavMusicStore::ROOT+'/purchase_orders/:pro_id/delete'
  POST_CHECKOUT_BY_ID   = NavMusicStore::ROOT+'/purchase_orders/:pro_id/checkout'
  POST_ADD_ITEMS        = NavMusicStore::ROOT+'/purchase_orders/:pro_id/add_items'

  def self.nav_get_view_by_id(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}/view"
  end

  def self.nav_get_with_pro_sup_id(pro_sup_id, strict = false)
    return NavMusicStore::ROOT+"/purchase_orders/search/?pro_sup_id=#{pro_sup_id}"
  end

  def self.nav_get_edit_by_id(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}/edit"
  end

  def self.nav_post_update_by_id(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}"
  end

  def self.nav_post_delete_by_id(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}/delete"
  end

  def self.nav_post_checkout_by_id(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}/checkout"
  end

  def self.nav_post_add_items(pro_id)
    return NavMusicStore::ROOT+"/purchase_orders/#{pro_id}/add_items"
  end


end
