require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata < Module
  create_finder_methods :id, :brand, :name, :price

  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(attributes = nil)
    db = CSV.read(@@data_path)

    is_product_update = attributes[:id] ? true : false

    prod = Product.new(attributes)
    CSV.open(@@data_path, 'wb') do |csv|
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
    db = CSV.read(@@data_path)
    data = db.drop(1)
    all_products = data.map { |item| Product.new(id: item[0], brand: item[1], name: item[2], price: item[3].to_f)}
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

    data.select! { |item| item.id == index }

    if data.empty?
      raise ProductNotFoundError
    else
      return data[0]
    end
  end

  def self.destroy(product_id)
    index_to_delete = nil
    data = self.all
    index_to_delete = data.index { |item| item.id == product_id }

    if index_to_delete.nil?
      raise ProductNotFoundError
    end

    deleted_product = data.delete_at index_to_delete

    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
      data.each do |prod|
        csv << [prod.id, prod.brand, prod.name, prod.price]
      end
    end

    return deleted_product
  end

  def self.where(val)
    data = self.all
    data.select! { |item| item.send(val.keys.first) == val.values.first }
    return data
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
