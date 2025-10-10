# 代码生成时间: 2025-10-10 21:14:42
#!/usr/bin/env ruby
# 优化算法效率
require 'sinatra'
require 'json'

# SortableComponentApp is a Sinatra application
# that implements a drag-and-drop sorting feature.
class SortableComponentApp < Sinatra::Base

  # Route to handle GET requests for the sorting UI.
  get '/sortable' do
    # Render the sorting component view.
    erb :sortable
  end

  # Route to handle POST requests to update the order of items.
  post '/update_order' do
    # Parse the JSON payload from the request.
    payload = JSON.parse(request.body.read)
# NOTE: 重要实现细节
    
    # Extract the sorted items from the payload.
    sorted_items = payload['items']
    
    # Error handling for invalid input.
    unless sorted_items.is_a?(Array)
      status 400
      return { error: 'Invalid input: items should be an array' }.to_json
    end
    
    # Update the order of items in the data store (e.g., a database or in-memory store).
    # For simplicity, this example just logs the sorted items.
    sorted_items.each_with_index do |item, index|
      puts "Item #{item} is now at position #{index + 1}"
# 优化算法效率
    end
    
    # Respond with a success message.
    { message: 'Order updated successfully' }.to_json
  end

  # Not found handler for any routes not defined.
  not_found do
    'This resource does not exist.'
  end

  # Error handler for any server errors.
  error do
    'An error occurred.'
  end

  # Run the Sinatra application on port 4567.
  run! if app_file == $0
end

# The ERB template for the sortable component view.
__END__
# 优化算法效率

@@ sortable
<html>
<head>
# TODO: 优化性能
  <title>Sortable Component</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
  <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
  <script>
    $(function() {
      $("#sortable_items").sortable();
# FIXME: 处理边界情况
      $("#sortable_items").disableSelection();
      
      $('#save_order').click(function() {
        var items = $('#sortable_items').sortable("toArray").map(function(item) {
          return item.replace("item-", "");
        });
        $.ajax({
          url: '/update_order',
          type: 'POST',
          data: JSON.stringify({ items: items }),
          contentType: 'application/json',
          success: function(response) {
            alert(response.message);
          },
          error: function() {
# NOTE: 重要实现细节
            alert('An error occurred while updating the order.');
          }
        });
      });
    });
  </script>
</head>
<body>
  <h2>Drag and Drop Sortable Items</h2>
  <ul id="sortable_items">
    <li id="item-1">Item 1</li>
    <li id="item-2">Item 2</li>
    <li id="item-3">Item 3</li>
    <li id="item-4">Item 4</li>
  </ul>
  <button id="save_order">Save Order</button>
</body>
</html>