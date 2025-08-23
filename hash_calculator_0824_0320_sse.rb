# 代码生成时间: 2025-08-24 03:20:02
# HashCalculatorApp is a Sinatra application that calculates hash values for input strings.
class HashCalculatorApp < Sinatra::Base
  # GET route to display the hash calculator form.
  get '/' do
    erb :form
  end

  # POST route to calculate and display the hash value.
  post '/' do
    # Retrieve the input string from the form.
    input_string = params['input']

    # Handle the case where the input string is missing or empty.
    if input_string.nil? || input_string.empty?
      status 400
      return {
        error: 'Input string is required.'
      }.to_json
    end

    # Calculate the hash value using SHA256.
    hash_value = Digest::SHA256.hexdigest(input_string)

    # Return the calculated hash value as JSON.
    {
      hash_value: hash_value
    }.to_json
  end
end

# Start the Sinatra application on port 4567.
run! if __FILE__ == $0