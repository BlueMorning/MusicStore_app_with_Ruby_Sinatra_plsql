class NavMusicStore

  ROOT             = "/mstore"
  DATA_IMAGES_PATH = "/data_images/"

end


class NavArtists

  GET_INDEX         = NavMusicStore::ROOT+"/artists"
  GET_NEW           = NavMusicStore::ROOT+"/artists/new"
  POST_NEW          = NavMusicStore::ROOT+"/artists"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/artists/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/artists/:art_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id/delete'

  def self.nav_get_with_filters(art_name)
    return NavMusicStore::ROOT+"/artists?art_name=#{art_name}"
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
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/genres/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/genres/:gen_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/genres/:gen_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/genres/:gen_id/delete'

  def self.nav_get_with_filters(gen_name)
    return NavMusicStore::ROOT+"/genres/?gen_name=#{gen_name}"
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


class NavStockAlbums

  GET_INDEX         = NavMusicStore::ROOT+"/albums_in_stock"
  GET_NEW           = NavMusicStore::ROOT+"/albums_in_stock/new"
  POST_NEW          = NavMusicStore::ROOT+"/albums_in_stock"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/albums_in_stock/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/albums_in_stock/:sto_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/albums_in_stock/:sto_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/albums_in_stock/:sto_id/delete'

  def self.nav_get_with_filters(alb_title)
    return NavMusicStore::ROOT+"/albums_in_stock?alb_title=#{alb_title}"
  end

  def self.nav_get_edit_by_id(sto_id)
    return NavMusicStore::ROOT+"/albums_in_stock/#{sto_id}/edit"
  end

  def self.nav_post_update_by_id(sto_id)
    return NavMusicStore::ROOT+"/albums_in_stock/#{sto_id}"
  end

  def self.nav_post_delete_by_id(sto_id)
    return NavMusicStore::ROOT+"/albums_in_stock/#{sto_id}/delete"
  end
end
