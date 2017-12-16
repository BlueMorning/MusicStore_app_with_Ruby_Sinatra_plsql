require_relative('./../helper/dbhelper')


class Album

  attr_reader   :alb_id
  attr_accessor :alb_title, :alb_price, :alb_cover_image, :alb_art_id, :alb_gen_id

  def initialize(options)
    @alb_id             = options['alb_id'] if options['alb_id']
    @alb_title          = options['alb_title']
    @alb_price          = options['alb_price']
    @alb_cover_image    = options['alb_cover_image']
    @alb_art_id         = options['alb_art_id']
    @alb_gen_id         = options['alb_gen_id']
  end


  # Perform an insert or an update depending on the value of ald_id
  def save()
    if(@alb_id)
      update()
    else
      insert()
    end
  end


  #Class method
  # Delete from the table albums the given object and return the object
  def self.delete(album)
    query   = "DELETE FROM albums WHERE alb_id = $1"
    DbHelper.run_sql(query, [album.alb_id])
    return album
  end

  # Delete from the table albums the given alb_id
  def self.delete_by_id(alb_id)
    query   = "DELETE FROM albums WHERE alb_id = $1"
    DbHelper.run_sql(query, [alb_id])
  end

  # Find the album on the given alb_id
  def self.find_by_id(alb_id)
    query   = "SELECT alb_id, alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id FROM artists
               WHERE alb_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [alb_id], Album)
  end


  private

  def insert()
    query   = "INSERT INTO albums (alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id)
               VALUES ($1, $2, $3, $4, $5) RETURNING alb_id"
    @alb_id = DbHelper.run_sql_return_first_row_column_value(query,
      [@alb_title,
       @alb_price,
       @alb_cover_image,
       @alb_art_id,
       @alb_gen_id], 'alb_id');
  end

  def update()
    query   = "UPDATE albums SET (alb_title, alb_price, alb_cover_image, alb_art_id, alb_gen_id) =
                                 ($1, $2, $3, $4, $5) WHERE alb_id = $6"
    @alb_id = DbHelper.run_sql(query,
      [@alb_title,
       @alb_price,
       @alb_cover_image,
       @alb_art_id,
       @alb_gen_id,
       @alb_id]);
  end

end
