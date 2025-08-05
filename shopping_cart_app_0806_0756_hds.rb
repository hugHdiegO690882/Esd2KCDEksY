# 代码生成时间: 2025-08-06 07:56:58
# ShoppingCartApp - A simple Sinatra application to demonstrate a shopping cart functionality.
class ShoppingCartApp < Sinatra::Base

  # Define a hash to simulate a database of products.
  # In a real-world scenario, you would use a database.
  PRODUCTS = {
    'apple' => { price: 0.50, quantity: 10 },
    'banana' => { price: 0.20, quantity: 15 },
    'orange' => { price: 0.30, quantity: 12 }
  }

  # Set the session secret key for Sinatra's session management.
  set :session_secret, 'super_secret_key'

  # Helper method to add a product to the cart.
  def add_to_cart(product_id)
    if PRODUCTS[product_id]
      @cart = session[:cart] ||= {}
      @cart[product_id] ||= 0
      @cart[product_id] += 1
    else
      status 404
      "Product not found."
    end
  end

  # Helper method to remove a product from the cart.
  def remove_from_cart(product_id)
    if session[:cart] && session[:cart][product_id]
      @cart = session[:cart]
      @cart[product_id] -= 1
      if @cart[product_id] == 0
        @cart.delete(product_id)
      end
    else
      status 404
      "Product not found in cart."
    end
  end

  # Home page route.
  get '/' do
    @products = PRODUCTS
    erb :index
  end

  # Route to add a product to the cart.
  post '/add_to_cart/:product_id' do
    result = add_to_cart(params['product_id'])
    if result.is_a?(String)
      result
    else
      redirect to('/shopping_cart')
    end
  end

  # Route to remove a product from the cart.
  post '/remove_from_cart/:product_id' do
    result = remove_from_cart(params['product_id'])
    if result.is_a?(String)
      result
    else
      redirect to('/shopping_cart')
    end
  end

  # Route to display the shopping cart.
  get '/shopping_cart' do
    @cart = session[:cart] || {}
    erb :cart
  end

  # Route to clear the shopping cart.
  post '/clear_cart' do
    session[:cart] = {}
    redirect to('/shopping_cart')
  end

end

# Views
# index.erb
# This is the template for the home page.
<<-'ERB'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Shopping Cart App</title>
</head>
<body>
  <h1>Products</h1>
  <ul>
  <% @products.each do |id, product| %>
    <li><%= id %> - $<%= product[:price] %>
      <form action="/add_to_cart/<%= id %>" method="post">
        <button type="submit">Add to Cart</button>
      </form>
    </li>
  <% end %>
  </ul>
  <a href="/shopping_cart">View Cart</a>
</body>
</html>
ERB

# cart.erb
# This is the template for the shopping cart.
<<-'ERB'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Shopping Cart</title>
</head>
<body>
  <h1>Shopping Cart</h1>
  <ul>
  <% @cart.each do |id, quantity| %>
    <li><%= id %> - $<%= PRODUCTS[id][:price] %> x <%= quantity %>
      <form action="/remove_from_cart/<%= id %>" method="post">
        <button type="submit">Remove</button>
      </form>
    </li>
  <% end %>
  </ul>
  <form action="/clear_cart" method="post">
    <button type="submit">Clear Cart</button>
  </form>
  <a href="/">Back to Products</a>
</body>
</html>
ERB