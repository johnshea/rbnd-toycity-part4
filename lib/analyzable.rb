module Analyzable

  def average_price(array_of_products)

    sum_of_product_prices = array_of_products.inject(0) do |sum, product|
      sum + product.price
    end

    average_price = sum_of_product_prices / array_of_products.length

    return average_price.round(2)
  end

  def print_report(array_of_products)
    calculated_average_price = average_price(array_of_products)
    brand_counts = count_by_brand(array_of_products)
    name_counts = count_by_name(array_of_products)

    report_text = ""
    report_text += "Average Price: $#{calculated_average_price}\n"
    report_text += "Inventory by Brand:\n"
    brand_counts.each do |key, value|
      report_text +=  "  - #{key}: #{value}\n"
    end
    report_text +=  "Inventory by Name:\n"
    name_counts.each do |key, value|
      report_text +=  "  - #{key}: #{value}\n"
    end
    return report_text
  end

  def count_by_brand(array_of_products)

    brand_counts = Hash.new
    array_of_products.each do |product|
      if brand_counts.has_key? product.brand
        brand_counts[product.brand] += 1
      else
        brand_counts[product.brand] = 1
      end
    end
    return brand_counts
  end


  def count_by_name(array_of_products)

    name_counts = Hash.new
    array_of_products.each do |product|
      if name_counts.has_key? product.name
        name_counts[product.name] += 1
      else
        name_counts[product.name] = 1
      end
    end
    return name_counts
  end
end
