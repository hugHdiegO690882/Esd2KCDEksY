# 代码生成时间: 2025-08-31 13:38:43
# HashCalculator is a Sinatra application that calculates the hash value of a given string.
class HashCalculator < Sinatra::Base
  # Route to handle GET requests to the root path.
  # It displays the simple form to input the string to be hashed.
  get "/" do
    erb :index
  end

  # Route to handle POST requests to the root path.
  # It calculates the hash value of the input string and returns it.
  post "/" do
    # Check if the input is provided and is not empty.
    input_string = params[:input]
    if input_string.nil? || input_string.empty?
      # Return an error message if no input is provided.
      "Error: No input provided."
    else
      # Calculate the hash value using SHA256 algorithm.
      hash_value = Digest::SHA256.hexdigest(input_string)
      # Return the hash value in a JSON format.
      { hash: hash_value }.to_json
    end
  end

  # Route to handle GET requests to the "/about" path.
  # It displays information about the application.
  get "/about" do
    "This is a simple hash calculator tool that calculates the SHA256 hash of a given string."
  end

  # Register an error handler for 404 (not found) errors.
  error do
    "Error: Page not found."
  end

  # Register an error handler for 500 (internal server error) errors.
  error do
    "Error: Internal server error."
  end
end

# Register the views in the 'views' directory.
configure do
  set :views, File.dirname(__FILE__) + "/views"
end

# Start the Sinatra application if this file is executed directly.
run HashCalculator if __FILE__ == $0
