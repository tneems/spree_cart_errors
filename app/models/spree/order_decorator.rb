module Spree
  Order.class_eval do
    def add_variant(variant, quantity = 1)
      current_item = find_line_item_by_variant(variant)
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

      # NOTE: This line is commented out from the original method
      # self.reload
      current_item
    end
  end
end