Deface::Override.new(:virtual_path  => "spree/orders/_line_item",
                     :name => 'line_overages',
                     :insert_before => "tr:first-of-type",
                     :partial => "spree/orders/line_overages",
                     :original => '388458e40037a8324d566e0ddbcab6a58c23d9a4',
                     :disabled => false)
