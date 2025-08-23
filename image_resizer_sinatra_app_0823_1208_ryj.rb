# 代码生成时间: 2025-08-23 12:08:10
# ImageResizerSinatraApp class
class ImageResizerSinatraApp < Sinatra::Base

  # POST /resize
  # Endpoint to receive image resizing requests
  post '/resize' do
    # Check if the request has the file part
    unless params[:images]
      halt 400, { error: 'No images provided' }.to_json
    end

    # Initialize an empty array to store resized image paths
    resized_images = []

    # Process each file in the images array
    params[:images].each do |image|
      next unless image[:tempfile]

      # Create a MiniMagick image object from the uploaded file
      begin
        image_obj = MiniMagick::Image.read(image[:tempfile].path)
      rescue MiniMagick::Error
        halt 400, { error: 'Invalid image file' }.to_json
      end

      # Define the target size
      target_size = params[:target_size] || '300x300'

      # Resize the image
      image_obj.resize target_size

      # Generate a unique filename for the resized image
      resized_filename = "resized_#{Time.now.to_i}#{File.extname(image[:filename])}"

      # Save the resized image to the disk
      image_obj.write resized_filename

      # Add the resized image path to the array
      resized_images << resized_filename
    end

    # Return the array of resized image paths as JSON
    { resized_images: resized_images }.to_json
  end
end

# Run the Sinatra application
run ImageResizerSinatraApp