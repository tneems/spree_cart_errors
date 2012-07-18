Deface::Override.new(:virtual_path  => "spree/orders/_form",
                     :name => 'log_overages',
                     :replace => "code[erb-loud]:contains('spree/shared/error_messages')",
                     :partial => "spree/orders/error_messages",
                     :original => '909f37f4edcb5d5e2247f1c4b3a8abbe42e437d7',
                     :disabled => false)
