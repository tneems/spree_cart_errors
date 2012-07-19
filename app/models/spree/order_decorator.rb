module Spree
  Order.class_eval do
    def add_variant(variant, quantity = 1)
      current_item = contains?(variant)
      if current_item
        current_item.quantity += quantity
        current_item.save
      else
        current_item = LineItem.new
        current_item.variant = variant
        current_item.price   = variant.price

        # Add OH qty if there are not enough available then add the rest of the qty to present an error message
        if quantity > variant.on_hand
          current_item.quantity = variant.on_hand
          self.line_items << current_item
          current_item.quantity = quantity
        else
          current_item.quantity = quantity
          self.line_items << current_item
        end
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
      # undoing d08be0fc90cb1a7dbb286eb214de6b24f4b46635
      # self.reload
      current_item
    end
  end
end