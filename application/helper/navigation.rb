class NavMusicStore

  ROOT             = "/mstore"
  DATA_IMAGES_PATH = "/data_images/"

  def self.all_front_pages()
    pages = []

    pages.push({"link_path" => NavGenres::GET_INDEX,  "link_name" =>   "Genres"}) #Genres
    pages.push({"link_path" => NavArtists::GET_INDEX, "link_name" =>  "Artists"}) #Artists
    pages.push({"link_path" => NavAlbums::GET_INDEX,  "link_name" =>   "Albums"}) #Albums
    # pages.push() #Purchases
    # pages.push() #Suppliers
    # pages.push() #Sales
    # pages.push() #Customers

    return pages
  end


end


class NavArtists

  GET_INDEX         = NavMusicStore::ROOT+"/artists"
  GET_NEW           = NavMusicStore::ROOT+"/artists/new"
  POST_NEW          = NavMusicStore::ROOT+"/artists"
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/artists/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/artists/:art_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/artists/:art_id/delete'

  def self.nav_get_with_art_name(art_name, strict = false)
    return NavMusicStore::ROOT+"/artists/?art_name=#{art_name}&strict=#{strict}"
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

  def self.nav_get_with_gen_name(gen_name, strict = false)
    return NavMusicStore::ROOT+"/genres/?gen_name=#{gen_name}&strict=#{strict}"
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
  GET_WITH_FILTERS  = NavMusicStore::ROOT+"/albums/?"
  GET_EDIT_BY_ID    = NavMusicStore::ROOT+"/albums/:alb_id/edit"
  POST_UPDATE_BY_ID = NavMusicStore::ROOT+'/albums/:alb_id'
  POST_DELETE_BY_ID = NavMusicStore::ROOT+'/albums/:alb_id/delete'

  def self.nav_get_with_art_name(art_name)
    return NavMusicStore::ROOT+"/albums/?art_name=#{art_name}"
  end

  def self.nav_get_with_gen_id(alb_gen_id)
    return NavMusicStore::ROOT+"/albums/?alb_gen_id=#{alb_gen_id}"
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
