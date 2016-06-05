require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module
  create_finder_methods :id, :brand, :name, :price

  def self.create(attributes = nil)
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    db = CSV.read(@data_path)

    is_product_update = attributes[:id] ? true : false

    prod = Product.new(attributes)
    CSV.open(@data_path, 'wb') do |csv|
      db.each do |data|
        if is_product_update && data[0].to_i == prod.id
          csv << [prod.id, prod.brand, prod.name, prod.price]
        else
          csv << data
        end
      end
      if !is_product_update
        csv << [prod.id, prod.brand, prod.name, prod.price]
      end
    end

    return prod
  end

  def self.all
    @data_path = File.dirname(__FILE__) + "/../data/data.csv"
    db = CSV.read(@data_path)
    data = db.drop(1)
    all_products = Array.new
    data.each do |item|
      product = Product.new(id: item[0], brand: item[1], name: item[2], price: item[3].to_f)
      all_products << product
    end
    return all_products
  end

  def self.first(n = 1)
    data = self.all

    if n == 1
      return data.first(1)[0]
    else
      return data.first(n)
    end
  end

  def self.last(n = 1)
    data = self.all

    if n == 1
      return data.last(1)[0]
    else
      return data.last(n)
    end

  end

  def self.find(index)
    data = self.all
    data.each do |item|
      if item.id == index
        return item
      end
    end
    raise ProductNotFoundError
  end

  def self.destroy(product_id)
    index_to_delete = nil
    data = self.all
    data.each_with_index do |item, i|
      if item.id == product_id
        index_to_delete = i
      end
    end

    if index_to_delete == nil
      raise ProductNotFoundError
      return
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

  def self.where(val)
    items = Array.new
    data = self.all
    data.each do |item|
      if val.keys[0] == :brand
        if item.brand == val.values[0]
          items << item
        end
      else
        if item.name == val.values[0]
          items << item
        end
      end
    end
    return items
  end

  def update(options={})
    prod = Product.find(@id)

    brand = options[:brand] ? options[:brand] : prod.brand
    name = options[:name] ? options[:name] : prod.name
    price = options[:price] ? options[:price] : prod.price

    new_product = Product.create(id: prod.id, brand: brand, name: name, price: price)

    return new_product
  end
end
