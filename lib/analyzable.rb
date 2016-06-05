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

    report_text = ""
    report_text += "Average Price: $#{calculated_average_price}\n"
    report_text += format_report_section("brand", array_of_products)
    report_text += format_report_section("name", array_of_products)

    return report_text
  end

  def format_report_section(field, array_of_products)
    counts = counts(field, array_of_products)
    formatted_text = "Inventory by #{field.capitalize}:\n"
    formatted_text += format_counts(counts)
    return formatted_text
  end

  def format_counts(counted_items)
    formatted_text = ""
    counted_items.each do |key, value|
      formatted_text +=  "  - #{key}: #{value}\n"
    end
    return formatted_text
  end

  def count_by_brand(array_of_products)
    counts = counts("brand", array_of_products)
    return counts
  end

  def count_by_name(array_of_products)
    counts = counts("name", array_of_products)
    return counts
  end

  def counts(field, array_of_products)
    item_counts = Hash.new
    array_of_products.each do |product|
      if item_counts.has_key? product.send(field)
        item_counts[product.send(field)] += 1
      else
        item_counts[product.send(field)] = 1
      end
    end
    return item_counts
  end
end
