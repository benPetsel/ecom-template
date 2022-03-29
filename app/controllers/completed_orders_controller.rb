class CompletedOrdersController < ApplicationController
  before_action :set_completed_order, only: %i[ show edit update destroy ]
  layout 'portal'
  # GET /completed_orders or /completed_orders.json
  def index
    @completed_orders = CompletedOrder.all
    @eachOrder = []
    @completed_orders.each do |line_item|
        if @eachOrder.include? line_item.order_id
        else
          @eachOrder.push(line_item.order_id)
        end
    end
  end

  # GET /completed_orders/1 or /completed_orders/1.json
  def show
    id_to_lookup = params[:show]
    id_to_lookup = id_to_lookup[:sessioninfo]
    @show_full_order = CompletedOrder.where(order_id: id_to_lookup )
  end

  # GET /completed_orders/new
  def new
    @completed_order = CompletedOrder.new
  end

  # GET /completed_orders/1/edit
  def edit
  end

  # POST /completed_orders or /completed_orders.json
  def create
    @completed_order = CompletedOrder.new(completed_order_params)

    respond_to do |format|
      if @completed_order.save
        format.html { redirect_to completed_order_url(@completed_order), notice: "Completed order was successfully created." }
        format.json { render :show, status: :created, location: @completed_order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @completed_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /completed_orders/1 or /completed_orders/1.json
  def update
    respond_to do |format|
      if @completed_order.update(completed_order_params)
        format.html { redirect_to completed_order_url(@completed_order), notice: "Completed order was successfully updated." }
        format.json { render :show, status: :ok, location: @completed_order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @completed_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /completed_orders/1 or /completed_orders/1.json
  def destroy
    @completed_order.destroy

    respond_to do |format|
      format.html { redirect_to completed_orders_url, notice: "Completed order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_completed_order
      if params.has_key? :show
        @completed_order = CompletedOrder.all
      else
        @completed_order = CompletedOrder.find(params[:id])
      end
      
    end

    # Only allow a list of trusted parameters through.
    def completed_order_params
      params.require(:completed_order).permit(:sessioninfo, :order_id, :item_id, :item_name, :quantity, :charge, :address, :rate_id, :shipment_id, :carrier_acct_id)
    end
end
