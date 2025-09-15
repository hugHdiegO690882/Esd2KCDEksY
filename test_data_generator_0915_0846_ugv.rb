# 代码生成时间: 2025-09-15 08:46:11
# Test Data Generator using Ruby and Sinatra framework
# This program generates random test data for various purposes.

require 'sinatra'
require 'faker'

# Define the TestDataGenerator class
class TestDataGenerator
  # Generate random user data
  def generate_user_data
    Faker::Internet.email + "
" + Faker::Name.name + "
" + Faker::Address.street_address
  end

  # Generate random date data
  def generate_date_data
    Faker::Date.between(from: 2.years.ago, to: Date.today)
  end

  # Generate random number data
  def generate_number_data
    Faker::Number.number
  end
end

# Sinatra app setup
get '/' do
  # Redirect to the test data generation page
  redirect '/test_data'
end

# Route to handle test data generation
get '/test_data' do
  "<h2>Test Data Generator</h2>
<form action="/generate" method="post">
  <button type="submit">Generate Test Data</button>
</form>"
end

# Route to handle POST request for generating test data
post '/generate' do
  # Instantiate the TestDataGenerator class
  test_data_generator = TestDataGenerator.new

  # Generate test data
  user_data = test_data_generator.generate_user_data
  date_data = test_data_generator.generate_date_data
  number_data = test_data_generator.generate_number_data

  # Return the generated test data as JSON
  "{"user_data": ""#{user_data}"", "date_data": ""#{date_data}"", "number_data": ""#{number_data}""}
end
