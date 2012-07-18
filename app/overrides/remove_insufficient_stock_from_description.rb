Deface::Override.new(:virtual_path  => "spree/orders/_line_item",
                     :name => 'remove_insufficient_stock_from_description',
                     :remove => "code[erb-silent]:contains('insufficient_stock_lines')",
                     :closing_selector => "code[erb-silent]:contains('end')",
                     :disabled => false)
