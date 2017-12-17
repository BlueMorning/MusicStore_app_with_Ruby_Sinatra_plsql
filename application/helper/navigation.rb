class NavMusicStore

  ROOT             = "/mstore"
  DATA_IMAGES_PATH = "/data_images/"

end


class NavArtists

  GET_INDEX         = NavMusicStore::ROOT+"/artists"
  GET_NEW           = NavMusicStore::ROOT+"/artists/new"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/artists/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/artists/:id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/artists/:id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/artists/:id/delete'

  def self.nav_get_with_filters(art_name)
    return NavMusicStore::ROOT+"/artists?art_name=#{art_name}"
  end

  def self.nav_get_edit_by_id(id)
    return NavMusicStore::ROOT+"/artists/#{id}/edit"
  end

  def self.nav_post_update_by_id(id)
    return NavMusicStore::ROOT+"/artists/#{id}"
  end

  def self.nav_post_delete_by_id(id)
    return NavMusicStore::ROOT+"/artists/#{id}/delete"
  end
end


class NavGenres

  GET_INDEX         = NavMusicStore::ROOT+"/genres"
  GET_NEW           = NavMusicStore::ROOT+"/genres/new"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/genres/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/genres/:id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/genres/:id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/genres/:id/delete'

  def self.nav_get_with_filters(gen_name)
    return NavMusicStore::ROOT+"/genres/?gen_name=#{gen_name}"
  end

  def self.nav_get_edit_by_id(id)
    return NavMusicStore::ROOT+"/genres/#{id}/edit"
  end

  def self.nav_post_update_by_id(id)
    return NavMusicStore::ROOT+"/genres/#{id}"
  end

  def self.nav_post_delete_by_id(id)
    return NavMusicStore::ROOT+"/genres/#{id}/delete"
  end
end


class NavStockAlbums

  GET_INDEX         = NavMusicStore::ROOT+"/stocks"
  GET_NEW           = NavMusicStore::ROOT+"/stocks/new"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/stocks/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/stocks/:id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/stocks/:id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/stocks/:id/delete'

  def self.nav_get_with_filters(alb_title)
    return NavMusicStore::ROOT+"/stocks?alb_title=#{alb_title}"
  end

  def self.nav_get_edit_by_id(id)
    return NavMusicStore::ROOT+"/stocks/#{id}/edit"
  end

  def self.nav_post_update_by_id(id)
    return NavMusicStore::ROOT+"/stocks/#{id}"
  end

  def self.nav_post_delete_by_id(id)
    return NavMusicStore::ROOT+"/stocks/#{id}/delete"
  end
end
