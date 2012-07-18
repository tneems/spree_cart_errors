module Spree
  OrdersController.class_eval do
    # Adds a new item to the order (creating a new order if none already exists)
    #
    # Parameters can be passed using the following possible parameter configurations:
    #
    # * Single variant/quantity pairing
    # +:variants => {variant_id => quantity}+
    #
    # * Multiple products at once
    # +:products => {product_id => variant_id, product_id => variant_id}, :quantity => quantity +
    # +:products => {product_id => variant_id, product_id => variant_id}}, :quantity => {variant_id => quantity, variant_id => quantity}+
    def populate
      @order = current_order(true)

      params[:products].each do |product_id,variant_id|
        quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
        quantity = params[:quantity][variant_id.to_i].to_i if params[:quantity].is_a?(Hash)
        variant = Variant.find(variant_id)

        # TODO: commit to main project
        # items with insificient stock are getting lost when added to cart
        # Add a single unit to create and save the line item, then add then remaining qty
        # to bring the line to the requested qty
        if variant.on_hand < quantity && !@order.contains?(variant)
          @order.add_variant(Variant.find(variant_id), 1)
          @order.add_variant(Variant.find(variant_id), quantity - 1)
        else
          @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
        end
      end if params[:products]

      params[:variants].each do |variant_id, quantity|
        quantity = quantity.to_i
        @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
      end if params[:variants]

      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')

      # TODO: commit to main project
      # set the renders like #update
      respond_with(@order) do |format|
        format.html { 
          if @order.valid?
            redirect_to cart_path
          else
            render :action => "edit"
          end
        }
      end
    end
  end
end
