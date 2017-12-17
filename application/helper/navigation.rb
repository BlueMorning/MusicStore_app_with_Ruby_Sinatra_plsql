class NavMusicStore

  ROOT = "/mstore"

end


class NavArtists

  GET_ARTISTS_INDEX         = NavMusicStore::ROOT+"/artists"
  GET_ARTISTS_NEW           = NavMusicStore::ROOT+"/artists/new"
  GET_ARTISTS_BY_NAME       = NavMusicStore::ROOT+"/artists/:art_name"
  GET_ARTISTS_EDIT_BY_ID    = NavMusicStore::ROOT+"/artists/:id/edit"
  POST_ARTISTS_UPDATE_BY_ID = NavMusicStore::ROOT+'/artists/:id'
  POST_ARTISTS_DELETE_BY_ID = NavMusicStore::ROOT+'/artists/:id/delete'

end
