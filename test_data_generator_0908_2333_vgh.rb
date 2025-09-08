# 代码生成时间: 2025-09-08 23:33:59
# Test Data Generator API
#
# This Sinatra application generates test data.
# It includes error handling and documentation.

# Set up the environment for production or development
configure :development do
  set :logging, :debug
end

configure :production do
  set :logging, :warn
end

# Route to generate random test data
get '/test-data' do
  # Generate a random name
  name = "John Doe"

  # Generate a random email
  email = "#{name.gsub(' ', '_')}@example.com"

  # Generate a random phone number
  phone = "+1 (#{rand(10**3)}.#{rand(10**3)}.#{rand(10**4)})"

  # Generate a random address
  address = "#{rand(100)}. #{['Main St', 'Park Ave', '5th St'].sample}, #{['New York', 'Los Angeles', 'Chicago'].sample}, #{rand(10000)}"

  # Return the test data as a JSON object
  content_type :json
  "{
    "name": "#{CGI.escape(name)}",
    "email": "#{CGI.escape(email)}",
    "phone": "#{CGI.escape(phone)}",
    "address": "#{CGI.escape(address)}"
  }"
end

# Error handling for 404 Not Found
not_found do
  "Resource not found."
end
