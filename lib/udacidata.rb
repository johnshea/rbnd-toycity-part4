require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  def self.create(attributes = nil)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    db = CSV.read(@data_path)

    # values = db.drop(1)
    # item_in_db = false
    # item_id = -1
    # values.each do |id, brand, name, price|
    #   if brand == attributes[:brand] && name == attributes[:name]
    #     item_in_db = true
    #     item_id = id
    #   end
    # end

    # if !item_in_db
    #   #p "write to db"
      prod = Product.new(attributes)
      #p @data_path
      CSV.open(@data_path, 'wb') do |csv|
        db.each do |data|
          csv << data
        end
        csv << [prod.id, prod.brand, prod.name, prod.price]
      end
    # else
    #   attributes[:id] = item_id
    #   prod = Product.new(attributes)
    #   #p "exists in db"
    # end
    #p attributes

   #p prod
    return prod
  end

  def self.all
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    db = CSV.read(@data_path)
    data = db.drop(1)
    all_products = Array.new
    data.each do |item|
      product = Product.new(id: item[0], brand: item[1], name: item[2], price: item[3])
      all_products << product
    end
    return all_products
  end

  def self.first(n = 1)
    data = self.all
    # p data
    # p n
    # p data
    # p data.first(n)[0]
    if n == 1
      return data.first(1)[0]
    else
      return data.first(n)
    end
    # return data.first(n)[0]
  end

  def self.last(n = 1)
    data = self.all
    # p data
    # p n
    # p data
    # p data.first(n)[0]
    if n == 1
      return data.last(1)[0]
    else
      return data.last(n)
    end
    # return data.first(n)[0]
  end

  def self.find(index)
    data = self.all
    data.each do |item|
      if item.id == index
        return item
      end
    end
  end

  def self.destroy(product_id)
    index_to_delete = nil
    data = self.all
    data.each_with_index do |item, i|
      if item.id == product_id
        index_to_delete = i
      end
    end
    deleted_product = data.delete_at index_to_delete

    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    CSV.open(@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
      data.each do |prod|
        csv << [prod.id, prod.brand, prod.name, prod.price]
      end
    end

    return deleted_product
  end
end
