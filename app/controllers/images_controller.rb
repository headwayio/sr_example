class ImagesController < ApplicationController
  load_and_authorize_resource
  respond_to :json

  def create
    image_params[:image].open if image_params[:image].tempfile.closed?
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        format.html do
          redirect_to { render admin_images_path(@image), notice: 'Image was successfully created.' }
        end
        format.json { render json: { url: @image.image_url }, status: :ok }
      else
        format.html { redirect_to admin_images_path }
        format.json do
          render json: @image.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def image_params
    params.require(:image).permit(:image)
  end
end
