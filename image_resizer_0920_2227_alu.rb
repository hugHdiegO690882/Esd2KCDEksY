# 代码生成时间: 2025-09-20 22:27:23
# ImageResizer is a Sinatra application that resizes images.
class ImageResizer < Sinatra::Base
  # Endpoint to upload an image and resize it.
  # It expects a POST request with a file parameter named 'image'.
  post '/resize' do
    # Check if an image was uploaded.
    unless params['image'] && params['image'][0]
      return json_response({ error: 'No image provided' }, 400)
    end

    # Get the uploaded image.
    image = params['image'][0][:tempfile]
    # Get the desired size from the parameters.
    size = params['size'] || '100x100'

    # Create a MiniMagick::Image object.
    image_obj = MiniMagick::Image.read(image)

    # Resize the image.
    begin
      image_obj.resize size
    rescue MiniMagick::Error => e
      # Return an error message if resizing fails.
      return json_response({ error: "Failed to resize image: #{e.message}" }, 500)
    end

    # Save the resized image to a new file.
    resized_image = Tempfile.new(['resized_image', '.jpg'])
    image_obj.write resized_image.path
    resized_image.rewind

    # Send the resized image back to the client.
    content_type 'image/jpeg'
    resized_image.read
  end

  private

  # Helper method to return a JSON response.
  def json_response(body, status)
    content_type :json
    { message: 'success', data: body }.to_json + "
"
  end
end

# Run the Sinatra application if this file is executed directly.
run! if app_file == $0

# Note: This code assumes you have the 'mini_magick' gem installed.
# You can install it using the following command:
# gem install mini_magick
