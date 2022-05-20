class CompletedOrdersController < ApplicationController
  before_action :set_completed_order, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  
  layout 'portal'
  # GET /completed_orders or /completed_orders.json
  def index
    @completed_orders = CompletedOrder.all.order(created_at: :desc)
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
    @id_to_lookup = params[:show]
    @id_to_lookup = @id_to_lookup[:sessioninfo]
    @all_images = Image.all
    @show_full_order = CompletedOrder.where(order_id: @id_to_lookup )
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

  def mark
puts params[:id]
order_to_mark_done = CompletedOrder.where(order_id: params[:id] )
order_to_mark_done.each do |item|
  item.order_completed = true
  item.save!
end


redirect_to completed_orders_path
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
      params.require(:completed_order).permit(:name, :email, :sessioninfo, :order_id, 
      :item_id, :item_name, :quantity, :charge, :address, :rate_id, :shipment_id, 
      :carrier_acct_id, :session_identity, :secID, :order_completed, :recipient)
    end
end
