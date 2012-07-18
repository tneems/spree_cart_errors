module Spree
  Order.class_eval do
    # TODO: fix the cart error populating and make it work with the framekwork version of this method
    # Undo d08be0fc90cb1a7dbb286eb214de6b24f4b46635
    def add_variant(variant, quantity = 1)
      current_item = contains?(variant)
      if current_item
        current_item.quantity += quantity
        current_item.save
      else
        current_item = LineItem.new(:quantity => quantity)
        current_item.variant = variant
        current_item.price   = variant.price
        self.line_items << current_item
      end

      # populate line_items attributes for additional_fields entries
      # that have populate => [:line_item]
      Variant.additional_fields.select { |f| !f[:populate].nil? && f[:populate].include?(:line_item) }.each do |field|
        value = ''

        if field[:only].nil? || field[:only].include?(:variant)
          value = variant.send(field[:name].gsub(' ', '_').downcase)
        elsif field[:only].include?(:product)
          value = variant.product.send(field[:name].gsub(' ', '_').downcase)
        end
        current_item.update_attribute(field[:name].gsub(' ', '_').downcase, value)
      end

      # NOTE: This line was commented out from the original method
      # self.reload
      current_item
    end
  end
end