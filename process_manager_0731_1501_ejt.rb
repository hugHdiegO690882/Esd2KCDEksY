# 代码生成时间: 2025-07-31 15:01:20
# ProcessManager is a Sinatra application that provides basic process management functionality.
# It allows users to start, stop, and list processes.
class ProcessManager < Sinatra::Base

  # GET / - Displays the status of all processes
  get '/' do
    # Retrieve the list of processes and their status
    processes = `ps aux`.split("
")
    # Format the processes into a JSON response
    content_type :json
    processes.to_json
  end

  # POST /start - Starts a new process
  post '/start/:process_name' do |process_name|
    # Check if the process name is provided
    if process_name.empty?
      return error_response(400, "Process name is required")
    end

    # Start the process
    begin
      Process.spawn(process_name)
      status 201
      { message: "Process started successfully" }.to_json
    rescue => e
      error_response(500, e.message)
    end
  end

  # POST /stop/:process_name - Stops a process by name
  post '/stop/:process_name' do |process_name|
    # Check if the process name is provided
    if process_name.empty?
      return error_response(400, "Process name is required")
    end

    # Stop the process
    begin
      # Find the process by name and terminate it
      `killall #{process_name}`
      status 200
      { message: "Process stopped successfully" }.to_json
    rescue => e
      error_response(500, e.message)
    end
  end

  # Helper method to return error responses in JSON format
  def error_response(status, message)
    content_type :json
    status status
    { error: message }.to_json
  end

end

# Run the Sinatra application on port 4567
run! if app_file == $0