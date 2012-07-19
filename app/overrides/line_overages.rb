Deface::Override.new(:virtual_path  => "spree/orders/_line_item",
                     :name => 'line_overages',
                     :insert_before => "tr:first-of-type",
                     :partial => "spree/orders/line_overages",
                     :original => '8d20bf1c8f0b13933df6d34b71e99d076b94ea90',
                     :disabled => false)
