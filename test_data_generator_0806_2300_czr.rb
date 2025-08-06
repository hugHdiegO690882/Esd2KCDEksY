# 代码生成时间: 2025-08-06 23:00:44
# Test Data Generator application using Sinatra framework
# This application generates random test data using the Faker gem

# Initialize a Sinatra application
class TestDataGenerator < Sinatra::Base
  # Set the route for the root path to return a JSON with random data
  get '/' do
    # Generate random data using Faker
    data = {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      address: Faker::Address.street_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zip_code: Faker::Address.zip_code
    }
    # Return the generated data in JSON format
    content_type :json
    data.to_json
  end

  # Error handling for 404 Not Found errors
  not_found do
    content_type :json
    { error: 'Page not found' }.to_json
  end
end

# Run the application if this file is executed directly
run! if app_file == $0