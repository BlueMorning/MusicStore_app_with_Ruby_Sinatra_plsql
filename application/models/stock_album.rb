require_relative('./../helper/dbhelper')


class StockAlbum

  attr_reader :sto_id
  attr_accessor :sto_qty_available, :sto_qty_min, :sto_qty_max, :sto_alb_id, :album

  def initialize(options)
    @sto_id             = options['sto_id'] if options['sto_id']
    @sto_qty_available  = options['sto_qty_available']
    @sto_qty_min        = options['sto_qty_min']
    @sto_qty_max        = options['sto_qty_max']
    @sto_alb_id         = options['sto_alb_id']
    @album              = options['album']
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

  end

  def self.delete_by_id(sto_id)

  end

  def self.delete(sto_id)

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
