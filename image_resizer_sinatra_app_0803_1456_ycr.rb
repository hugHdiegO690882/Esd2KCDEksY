# 代码生成时间: 2025-08-03 14:56:54
# ImageResizerSinatraApp is a Sinatra application for batch resizing images.
class ImageResizerSinatraApp < Sinatra::Application

  # POST endpoint to handle image upload and resizing.
  post '/resize' do
    # Check if the request has the file parameter and it's not empty
    if params[:file] && !params[:file][:tempfile].nil?
      target_width = params[:width].to_i
      target_height = params[:height].to_i

      # Error handling for invalid dimensions
      if target_width <= 0 || target_height <= 0
        return "{"error": "Invalid dimensions provided. Width and height must be positive integers."}"
      end

      # Read the uploaded file using MiniMagick
      image = MiniMagick::Image.read(params[:file][:tempfile].read)

      # Error handling if the file is not an image
      unless image.valid?
        return "{"error": "Invalid image. Please upload a valid image file."}"
      end

      # Resize the image
      begin
        image.resize "#{target_width}x#{target_height}"
        image.write params[:file][:filename]
      rescue MiniMagick::Error => e
        # Return an error message if resizing fails
        return "{"error": "Failed to resize the image: #{e.message}"}"
      end

      # Return the path to the resized image
      "{"resized_image_path": "#{settings.public_folder}/#{params[:file][:filename]}"}"
    else
      # Return an error message if no file is uploaded
      "{"error": "No file uploaded."}"
    end
  end

  # Helper method to get the public folder path.
  helpers do
def public_folder
    "#{settings.root}/public"
  end
end

# Run the Sinatra application.
run! if app_file == $0