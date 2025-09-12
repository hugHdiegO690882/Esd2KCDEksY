# 代码生成时间: 2025-09-12 16:12:08
# Test Data Generator is a Sinatra application that generates test data
class TestDataGenerator < Sinatra::Base

  # Endpoint to generate a random user
  get '/user' do
    # Generate a random user data
    user_data = generate_random_user
    # Return the user data as JSON
    content_type :json
    user_data.to_json
  end

  private

  # Method to generate random user data
  def generate_random_user
    {
      "name" => Faker::Name.name,
      "email" => Faker::Internet.email,
      "address" => Faker::Address.street_address,
      "phone" => Faker::PhoneNumber.phone_number
    }
  end
end

# Run the Sinatra application
run! if app_file == $0