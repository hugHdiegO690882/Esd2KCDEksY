# 代码生成时间: 2025-08-03 05:12:26
# TestReportGenerator - Sinatra application for generating test reports
class TestReportGenerator < Sinatra::Base

  # Route to handle GET requests and display the form
  get '/' do
    erb :generate_form
  end

  # Route to handle POST requests and process test data
  post '/' do
    # Error handling for missing data
    unless params[:test_name] && params[:results]
      return "Missing required data"
    end

    # Generate report data structure
    test_name = params[:test_name]
    results = params[:results].split(',')

    # Save report to a file
    report = "Test Name: #{test_name}
Results: #{results.join(', ')}"
    File.open("#{test_name}_report.txt", 'w') do |file|
      file.write(report)
    end

    # Return success message with filename
    "Report generated successfully: #{test_name}_report.txt"
  end

  # Helper method to load the ERB template for the form
  def load_template(template)
    File.read("#{settings.views}/templates/#{template}.erb")
  end
end

# Run the Sinatra application
run! if __FILE__ == $0