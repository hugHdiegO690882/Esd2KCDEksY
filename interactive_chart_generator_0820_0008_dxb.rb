# 代码生成时间: 2025-08-20 00:08:00
# Interactive Chart Generator App
class InteractiveChartGenerator < Sinatra::Base

  # Set the public folder for static files
  set :public_folder, Proc.new { File.join(root, 'public') }

  # Serve the index page
  get '/' do
    erb :index
  end

  # Endpoint to generate chart data
  post '/generate-chart' do
    content_type :json
    # Parse JSON data from request body
    params = JSON.parse(request.body.read)

    # Error handling for missing data
    if params['data'].nil?
      status 400
      { error: 'No data provided' }.to_json
    else
      # Generate chart data based on the provided data
      chart_data = generate_chart_data(params['data'])
      # Return the chart data as JSON
      { chart_data: chart_data }.to_json
    end
  end

  private

  # Method to generate chart data
  # This method should be implemented to generate the actual chart data
  # based on the requirements of the charting library used
  def generate_chart_data(data)
    # Placeholder for chart data generation logic
    # This should be replaced with actual chart data generation code
    data
  end

end

# ERB template for the index page
__END__

@@index
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Interactive Chart Generator</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", function() {
      // Function to handle chart data submission
      function submitChartData() {
        const data = {
          labels: document.getElementById('labels').value,
          datasets: JSON.parse(document.getElementById('datasets').value)
        };

        fetch('/generate-chart', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({ data: data })
        }).then(response => response.json())
          .then(data => {
            const ctx = document.getElementById('myChart').getContext('2d');
            new Chart(ctx, {
              type: 'bar',
              data: data.chart_data,
              options: {}
            });
          }).catch(error => console.error('Error:', error));
      }
    });
  </script>
</head>
<body>
  <h1>Interactive Chart Generator</h1>
  <label for="labels">Labels:</label>
  <input type="text" id="labels" name="labels" placeholder="Enter labels separated by commas">
  <br><br>
  <label for="datasets">Datasets (JSON):</label>
  <textarea id="datasets" name="datasets" rows="4" cols="50" placeholder='{"label":"Example dataset","data":[10, 20, 30],"backgroundColor":["red","green","blue"]}'></textarea>
  <br><br>
  <button onclick="submitChartData()">Generate Chart</button>
  <br><br>
  <canvas id="myChart" width="400" height="400"></canvas>
</body>
</html>