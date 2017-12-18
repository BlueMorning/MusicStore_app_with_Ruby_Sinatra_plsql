require_relative('./../helper/dbhelper')
require_relative('./../models/artist')
require_relative('./../models/album')
require_relative('./../models/genre')


class Stock

  attr_reader :sto_id
  attr_accessor :sto_qty_available, :sto_qty_min, :sto_qty_max, :sto_alb_id

  def initialize(options, init_alb_art_gen = false)
    if(options != nil)
      @sto_id             = options['sto_id'] if options['sto_id']
      @sto_qty_available  = options['sto_qty_available']
      @sto_qty_min        = options['sto_qty_min']
      @sto_qty_max        = options['sto_qty_max']
      @sto_alb_id         = options['sto_alb_id']
    else
      @sto_id             = 0
      @sto_qty_available  = 0
      @sto_qty_min        = 0
      @sto_qty_max        = 0
      @sto_alb_id         = 0
    end
  end

  def save()
    if(@sto_id)
      update()
    else
      insert()
    end
  end

  #Class methods
  def self.find_by_id(sto_id)
    query = "SELECT sto_id, sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id
             FROM stocks WHERE sto_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [sto_id], Stock)
  end

  def self.find_all(limit = 0)
    query = "SELECT sto_id, sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id
             FROM stocks"

    if limit > 0
      query += " LIMIT #{limit}"
    end

    return DbHelper.run_sql_and_return_many_objects(query, [sto_id], Stock)
  end


  def self.delete_by_id(sto_id)
    query = "DELETE FROM stocks WHERE stocks.id = $1"
    DbHelper.run_sql(query, @sto_id)
  end



  private

  def insert()
    query = "INSERT INTO stocks (sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id)
                         VALUES ($1, $2, $3, $4) RETURNING sto_id"
     @sto_id = DbHelper.run_sql_return_first_row_column_value(query,
       [@sto_qty_available,
        @sto_qty_min,
        @sto_qty_max,
        @sto_alb_id], 'sto_id')
  end

  def update()
    query = "UPDATE stocks SET (sto_qty_available, sto_qty_min, sto_qty_max, sto_alb_id)
                         = ($1, $2, $3, $4) WHERE sto_id = $5"
    DbHelper.run_sql(query,
       [@sto_qty_available,
        @sto_qty_min,
        @sto_qty_max,
        @sto_alb_id,
        @sto_id])
  end


end
