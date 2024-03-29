class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  layout 'portal'
  


  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    if @content.categories 
      cat_text = @content.categories 
      @cat_arr = cat_text.split(',')
    end
  end

  def delete_second
    this_photo = Product.find(params[:id])
    this_photo.secondary_image.purge
    redirect_back(fallback_location: products_path)
  end

  # GET /products/1/edit
  def edit
    if @content.categories 
      cat_text = @content.categories 
      @cat_arr = cat_text.split(',')
    end
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:height, :width, :length, :weight,  :name, :catagory, 
      :description, :price, :old_price, :on_sale, :sold_out, :featured, :quantity, :image, 
      :secondary_image, :secondary_heading, :photos_attached, :visible, :dimensions_show, :color_option_1, :image_number)
    end
end
