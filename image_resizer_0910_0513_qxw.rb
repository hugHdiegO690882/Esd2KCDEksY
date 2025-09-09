# 代码生成时间: 2025-09-10 05:13:41
# ImageResizer is a Sinatra application to batch resize images.
class ImageResizer < Sinatra::Base

  # POST /resize to handle image upload and resizing.
  post '/resize' do
    # Check if the upload is a multipart form and if the file is present.
    if request.media_type == 'multipart/form-data' && params[:file]
      # Get the uploaded file.
      file = params[:file][:tempfile]
      # Get the filename and ensure it has an image extension.
      filename = params[:file][:filename]
      unless ['.jpg', '.jpeg', '.png', '.gif'].include?(File.extname(filename).downcase)
        return error_response('Unsupported file type.')
      end

      target_width = params[:width].to_i rescue 100 # Default to 100 if not provided.
      target_height = params[:height].to_i rescue 100 # Default to 100 if not provided.

      # Resize the image using MiniMagick.
      begin
        image = MiniMagick::Image.read(file)
        image.resize "#{target_width}x#{target_height}"
        image.write file.path

        # Send the resized image back as a response.
        content_type 'image/jpeg' # Assuming JPEG, adjust as needed based on original image type.
        return File.read(file.path)
      rescue MiniMagick::Error => e
        # Handle any errors that occur during resizing.
        return error_response("Failed to resize image: #{e.message}")
      end
    else
      # Return an error if no file or incorrect content type.
      return error_response('No file uploaded or incorrect content type.')
    end
  end

  private

  # Helper method to return a JSON error response.
  def error_response(message)
    content_type :json
    { error: message }.to_json
  end
end

# Start the Sinatra server on the default port if this file is executed directly.
run! if app_file == $0
