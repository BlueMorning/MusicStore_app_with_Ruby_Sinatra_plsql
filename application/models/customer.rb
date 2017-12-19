require_relative('./../helper/dbhelper')
require_relative('./../helper/navigation')


class Customer

  attr_reader :cus_id, :cus_name
  attr_accessor :cus_name

  def initialize(options)
    if(options != nil)
      @cus_id             = options['cus_id'].to_i if options['cus_id']
      @cus_name           = options['cus_name']

    else
      @cus_id             = 0
      @cus_name           = ""
    end
  end



  # Perform an insert or an update depending on the value of cus_id
  def save()
    if(@cus_id && @cus_id != 0) #if the row already exists
      update()
    else
      insert()
    end
  end




  # Class methods

  # Delete from the table customers the given object and return the object
  def self.delete(customer)
    query   = "DELETE FROM customers WHERE cus_id = $1"
    DbHelper.run_sql(query, [customer.cus_id])
    return customer
  end

  # Delete from the table customer the given cus_id
  def self.delete_by_id(cus_id)
    query   = "DELETE FROM customers WHERE cus_id = $1"
    DbHelper.run_sql(query, [cus_id])
  end

  # Find the customer on the given cus_id
  def self.find_by_id(cus_id)
    query   = "SELECT cus_id, cus_name FROM customers WHERE cus_id = $1"
    return DbHelper.run_sql_and_return_one_object(query, [cus_id], Customer)
  end

  # Find all the customers
  def self.find_all()
    query   = "SELECT cus_id, cus_name FROM customers"
    return DbHelper.run_sql_and_return_many_objects(query, [], Customer)
  end

  # Find all the customers whose name matches
  def self.search_all_by_name(cus_name, strict = false)
    if(! strict)
      query   = "SELECT cus_id, cus_name FROM customers WHERE lower(cus_name) LIKE lower($1)"
      return DbHelper.run_sql_and_return_many_objects(query, ["%#{cus_name}%"], Customer)
    else
      query   = "SELECT cus_id, cus_name FROM customers WHERE cus_name = $1"
      return DbHelper.run_sql_and_return_many_objects(query, ["#{cus_name}"], Customer)
    end

  end


  private

  # Insert the customer
  def insert()
    query   = "INSERT INTO customers (cus_name) VALUES ($1) RETURNING cus_id"
    @cus_id = DbHelper.run_sql_return_first_row_column_value(query, [@cus_name], 'cus_id').to_i;
  end

  # Update the customer
  def update()
    query   = "UPDATE customers SET cus_name = $1 WHERE cus_id = $2"
    DbHelper.run_sql(query, [@cus_name, @cus_id])
  end




end
