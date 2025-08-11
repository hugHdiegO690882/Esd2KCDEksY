# 代码生成时间: 2025-08-11 09:26:20
# MathToolbox is a simple Sinatra application providing basic math operations.
class MathToolbox < Sinatra::Base

  # GET route for the home page
  get '/' do
    "Welcome to the Math Toolbox!"
  end

  # POST route to perform addition
  post '/add' do
    # Parse the input from the client
    a = params['a'].to_f
    b = params['b'].to_f
    # Perform addition and return the result
# NOTE: 重要实现细节
    "The sum is: #{a + b}"
  end
# 扩展功能模块

  # POST route to perform subtraction
  post '/subtract' do
    # Parse the input from the client
    a = params['a'].to_f
    b = params['b'].to_f
    # Perform subtraction and return the result
    "The difference is: #{a - b}"
  end

  # POST route to perform multiplication
  post '/multiply' do
    # Parse the input from the client
    a = params['a'].to_f
    b = params['b'].to_f
# NOTE: 重要实现细节
    # Perform multiplication and return the result
    "The product is: #{a * b}"
  end

  # POST route to perform division
  post '/divide' do
    # Parse the input from the client
    a = params['a'].to_f
    b = params['b'].to_f
    # Check for division by zero
    if b == 0
      halt 400, "Error: Division by zero is not allowed."
    else
      # Perform division and return the result
      "The quotient is: #{a / b}"
    end
  end

end

# Run the application if the file is executed directly
run! if app_file == $0