module Spree
  OrdersController.class_eval do
    # Copied from v1.1.2 with respond with changed.
    # TODO: Fix to use respond_override, but it causes issues with #update and maybe other methods
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
        quantity = params[:quantity][variant_id].to_i if params[:quantity].is_a?(Hash)
        @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
      end if params[:products]

      params[:variants].each do |variant_id, quantity|
        quantity = quantity.to_i
        @order.add_variant(Variant.find(variant_id), quantity) if quantity > 0
      end if params[:variants]

      fire_event('spree.cart.add')
      fire_event('spree.order.contents_changed')
      respond_with(@order) { |format| format.html { 
        if @order.valid?
          redirect_to cart_path
        else
          render :action => "edit"
        end
      } }
    end

    # respond_override :populate => {
    #   :html => {
    #     :success => lambda {
    #       redirect_to cart_path
    #     },
    #     :failure => lambda {
    #       render :action => "edit"
    #     }
    #   }
    # }
  end
end