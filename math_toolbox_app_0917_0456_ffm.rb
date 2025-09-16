# 代码生成时间: 2025-09-17 04:56:29
# MathToolboxApp is a simple Sinatra application that provides basic math operations.
class MathToolboxApp < Sinatra::Base

  # Set the route for the root path to show a welcome message.
  get '/' do
    erb :index
  end

  # Route to handle addition operation.
  post '/add' do
    # Parse the input parameters.
    param1 = params['number1'].to_f
    param2 = params['number2'].to_f

    # Perform the addition operation.
    sum = param1 + param2

    # Return the result as JSON.
    {
      number1: param1,
      number2: param2,
      result: sum,
      operation: 'add'
    }.to_json
  end

  # Route to handle subtraction operation.
  post '/subtract' do
    param1 = params['number1'].to_f
    param2 = params['number2'].to_f

    # Perform the subtraction operation.
    difference = param1 - param2

    {
      number1: param1,
      number2: param2,
      result: difference,
      operation: 'subtract'
    }.to_json
  end

  # Route to handle multiplication operation.
  post '/multiply' do
    param1 = params['number1'].to_f
    param2 = params['number2'].to_f

    # Perform the multiplication operation.
    product = param1 * param2

    {
      number1: param1,
      number2: param2,
      result: product,
      operation: 'multiply'
    }.to_json
  end

  # Route to handle division operation.
  post '/divide' do
    param1 = params['number1'].to_f
    param2 = params['number2'].to_f

    # Check for division by zero.
    if param2 == 0
      'Error: Division by zero is not allowed.'
    else
      # Perform the division operation.
      quotient = param1 / param2

      {
        number1: param1,
        number2: param2,
        result: quotient,
        operation: 'divide'
      }.to_json
    end
  end

  # Define an error handler for Sinatra.
  not_found do
    'This page could not be found.'
  end

  # Define an error handler for any other HTTP errors.
  error do
    'An error occurred.'
  end

  # Define an index view for the application.
  get '/' do
    erb :index
  end
end

# Run the Sinatra application if the script is executed directly.
run! if app_file == $0