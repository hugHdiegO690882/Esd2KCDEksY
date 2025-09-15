# 代码生成时间: 2025-09-16 03:55:03
# Inventory Management System using Sinatra framework
class InventoryManagement < Sinatra::Base
  # Initialize an empty inventory hash
  @@inventory = {}

  # Endpoint to display the inventory
  get '/inventory' do
    # Check if the inventory is empty and return an appropriate message
    if @@inventory.empty?
      "Inventory is empty."
    else
      # Return the current state of the inventory as a JSON object
      content_type :json
      @@inventory.to_json
    end
  end

  # Endpoint to add an item to the inventory
  post '/inventory/:item' do
    # Extract item name and quantity from the request body
    item = params['item']
    quantity = params['quantity'].to_i

    # Check for valid input
    if item.nil? || quantity <= 0
      # Return an error message if input is invalid
      halt 400, {'Content-Type' => 'text/plain'}, 'Invalid item or quantity'
    else
      # Update the inventory hash with the new item and quantity
      @@inventory[item] = @@inventory.fetch(item, 0) + quantity
      # Return the updated inventory as a JSON object
      content_type :json
      @@inventory.to_json
    end
  end

  # Endpoint to remove an item from the inventory
  delete '/inventory/:item' do
    # Extract item name from the request path
    item = params['item']

    # Check if the item exists in the inventory
    if @@inventory.include?(item)
      # Remove the item from the inventory
      @@inventory.delete(item)
      # Return the updated inventory as a JSON object
      content_type :json
      @@inventory.to_json
    else
      # Return an error message if the item does not exist
      halt 404, {'Content-Type' => 'text/plain'}, 'Item not found'
    end
  end

  # Endpoint to update the quantity of an existing item in the inventory
  put '/inventory/:item' do
    # Extract item name and new quantity from the request body
    item = params['item']
    new_quantity = params['quantity'].to_i

    # Check for valid input
    if item.nil? || new_quantity < 0
      # Return an error message if input is invalid
      halt 400, {'Content-Type' => 'text/plain'}, 'Invalid item or quantity'
    elsif !@@inventory.include?(item)
      # Return an error message if the item does not exist
      halt 404, {'Content-Type' => 'text/plain'}, 'Item not found'
    else
      # Update the quantity of the existing item in the inventory
      @@inventory[item] = new_quantity
      # Return the updated inventory as a JSON object
      content_type :json
      @@inventory.to_json
    end
  end

  # Run the Sinatra application on port 4567
  run! if app_file == $0
end