# 代码生成时间: 2025-09-12 04:42:19
# ProcessManager is a Sinatra application that handles process management.
class ProcessManager < Sinatra::Base
  # Home page, displays a simple message.
  get '/' do
    erb :index
  end

  # Endpoint to start a new process.
  post '/start' do
    content_type :json
    begin
      # Start the process and get the process ID.
      pid = spawn('sleep', '10')
      Process.detach(pid)
      { pid: pid }.to_json
    rescue => e
      # Handle errors and return a JSON response with error details.
      { error: e.message }.to_json
    end
  end

  # Endpoint to stop a process by its ID.
  post '/stop' do
    content_type :json
    begin
      pid = params['pid'].to_i
      Process.kill('TERM', pid)
      { message: 'Process terminated' }.to_json
    rescue => e
      { error: e.message }.to_json
    end
  end

  # Endpoint to list all processes.
  get '/processes' do
    content_type :json
    processes = `ps aux`
    { processes: processes }.to_json
  end

  # Error handling for 404 Not Found.
  not_found do
    content_type :json
    { error: 'Not Found' }.to_json
  end

  # Error handling for errors.
  error do
    error = request.env['sinatra.error']
    content_type :json
    { error: error.message }.to_json
  end
end

# Run the app if it's the main file.
run! if __FILE__ == $0
