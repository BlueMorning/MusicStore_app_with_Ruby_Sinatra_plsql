require_relative('./../helper/dbhelper')
require_relative('./../helper/navigation')


class Supplier

  attr_reader :sup_id, :sup_name
  attr_accessor :sup_name

  def initialize(options)
    if(options != nil)
      @sup_id             = options['sup_id'].to_i if options['sup_id']
      @sup_name           = options['sup_name']
    else
      @sup_id             = 0
      @sup_name           = ""
    end
  end



  # Perform an insert or an update depending on the value of sup_id
  def save()
    if(@sup_id && @sup_id != 0) #if the row already exists
      update()
    else
      insert()
    end
  end

  def nb_purchases()
    query = "SELECT COUNT(pro_id) nb_purchases FROM purchase_orders WHERE purchase_orders.pro_sup_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [@sup_id], 'nb_purchases').to_i;
  end

  def total_amount()
    query           = "SELECT SUM(pro_total_price) total_amount FROM purchase_orders WHERE purchase_orders.pro_sup_id = $1"
    total_amount    = DbHelper.run_sql_return_first_row_column_value(query, [@sup_id], 'total_amount');
    if(total_amount == nil)
      return 0
    else
      return total_amount.to_i
    end
  end


  # Class methods

  def self.can_be_deleted(sup_id)
    query = "SELECT COUNT(purchase_orders.pro_id) nb_references from purchase_orders WHERE purchase_orders.pro_sup_id = $1"
    return DbHelper.run_sql_return_first_row_column_value(query, [sup_id], 'nb_references').to_i == 0;
  end

  # Delete from the table supplier the given sup_id
  def self.delete_by_id(sup_id)
    if(Supplier.can_be_deleted(sup_id))
      query   = "DELETE FROM suppliers WHERE sup_id = $1"
      DbHelper.run_sql(query, [sup_id])
      return true
    else
      return false
    end
  end

  # Find the supplier on the given sup_id
  def self.find_by_id(sup_id)
    query   = "SELECT sup_id, sup_name FROM suppliers WHERE sup_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [sup_id], Supplier)
  end

  # Find all the suppliers
  def self.find_all()
    query   = "SELECT sup_id, sup_name FROM suppliers"
    return DbHelper.run_sql_and_return_many_objects(query, [], Supplier)
  end

  # Find all the suppliers whose name matches
  def self.search_all_by_name(sup_name, strict = false)
    if(! strict)
      query   = "SELECT sup_id, sup_name FROM suppliers WHERE lower(sup_name) LIKE lower($1)"
      return DbHelper.run_sql_and_return_many_objects(query, ["%#{sup_name}%"], Supplier)
    else
      query   = "SELECT sup_id, sup_name FROM suppliers WHERE sup_name = $1"
      return DbHelper.run_sql_and_return_many_objects(query, ["#{sup_name}"], Supplier)
    end

  end


  private

  # Insert the supplier
  def insert()
    query   = "INSERT INTO suppliers (sup_name) VALUES ($1) RETURNING sup_id"
    @sup_id = DbHelper.run_sql_return_first_row_column_value(query, [@sup_name], 'sup_id').to_i;
  end

  # Update the supplier
  def update()
    query   = "UPDATE suppliers SET sup_name = $1 WHERE sup_id = $2"
    DbHelper.run_sql(query, [@sup_name, @sup_id])
  end




end
