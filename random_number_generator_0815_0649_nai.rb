# 代码生成时间: 2025-08-15 06:49:28
# RandomNumberGenerator is a Sinatra application that generates random numbers.
class RandomNumberGenerator < Sinatra::Base

  # GET request to '/' endpoint, returns a random number between 1 and 100.
  get '/' do
    # Error handling if the request parameters are not provided or invalid.
    if params.empty?
      status 400
      { error: 'No parameters provided' }.to_json
    else
      # Extract the range from the query parameters
# 优化算法效率
      range = params['range']
      
      # Validate the range parameter
      unless range && range.match(/^\d+\.\.\d+$/)
        status 400
        { error: 'Invalid range format. Expected format: 1..10' }.to_json
      else
        # Split the range into start and end values
        start, end = range.split('..').map(&:to_i)
        
        # Generate a random number within the specified range
        random_number = Random.rand(start..end)
        
        # Return the random number as JSON
        { number: random_number }.to_json
      end
    end
  end

end

# Run the application on port 4567
run! if app_file == $0