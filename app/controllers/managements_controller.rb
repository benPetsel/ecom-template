class ManagementsController < ApplicationController
  before_action :set_management, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  layout 'portal'
 
  # GET /managements or /managements.json
  def index
    
    @managements = Management.all
  end

  # GET /managements/1 or /managements/1.json
  def show
  end

  # GET /managements/new
  def new
    @management = Management.new
  end

  # GET /managements/1/edit
  def edit
  end

  # POST /managements or /managements.json
  def create
    @management = Management.new(management_params)

    respond_to do |format|
      if @management.save
        format.html { redirect_to management_url(@management), notice: "Management was successfully created." }
        format.json { render :show, status: :created, location: @management }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @management.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /managements/1 or /managements/1.json
  def update
    respond_to do |format|
      if @management.update(management_params)
        format.html { redirect_to management_url(@management), notice: "Management was successfully updated." }
        format.json { render :show, status: :ok, location: @management }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @management.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managements/1 or /managements/1.json
  def destroy
    @management.destroy

    respond_to do |format|
      format.html { redirect_to managements_url, notice: "Management was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_management
      @management = Management.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def management_params
      params.require(:management).permit(:contact_page, :about_page, :about_text, :shop_text, 
      :phone_card, :phone_card_text, :phone, :brand_name, :email_card, :email_card_text, :email, 
      :buisness_card, :buisness_address, :address_card_text, :footer_text, :home_page_text, :testimonials, 
      :testimonial_1_name, :testimonial_1_text, :testimonial_2_name, :testimonial_2_text, :testimonial_3_name, 
      :testimonial_3_text, :twitter, :facebook, :instagram, :about_pic, :logo, :ship_zip, :ship_state , :ship_city , :ship_company,
      :ship_street, :tax_rate, :title_tag, :categories, :cart_notice_inuse, :cart_notice)
    end
end
