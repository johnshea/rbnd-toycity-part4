class Module
  def create_finder_methods(*attributes)

    attributes.each do |attribute|
      class_eval("def self.find_by_#{attribute}(val); data = self.all; data.each do |item|; if item.#{attribute} == val; return item; end; end; end;")
    end
  end
end
