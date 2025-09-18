# 代码生成时间: 2025-09-19 04:33:49
# ConfigManager is a Sinatra application for managing configuration files.
class ConfigManager < Sinatra::Application

  # Set the root directory for the application
  set :root, File.dirname(__FILE__)

  # Define the location where configuration files will be stored
  set :config_dir, File.join(root, 'config')

  # Ensure the configuration directory exists
  unless Dir.exist?(settings.config_dir)
    Dir.mkdir(settings.config_dir)
  end

  # Endpoint to list all configuration files
  get '/config' do
    # Check if the config directory exists
    unless Dir.exist?(settings.config_dir)
      status 500
      'Configuration directory does not exist.'
      return
    end

    # List all files in the config directory
    Dir.entries(settings.config_dir).select { |f| File.file?(File.join(settings.config_dir, f)) }.to_json
  end

  # Endpoint to retrieve a specific configuration file
  get '/config/:filename' do
    # Check if the requested file exists
    file_path = File.join(settings.config_dir, params[:filename])
    if File.exist?(file_path)
      # Read and return the file content
      content_type :json
      File.read(file_path).to_json
    else
      status 404
      'Configuration file not found.'
    end
  end

  # Endpoint to create or update a configuration file
  post '/config/:filename' do
    file_path = File.join(settings.config_dir, params[:filename])
    # Check if the file already exists and handle it accordingly
    if File.exist?(file_path)
      'Configuration file already exists. Use PUT to update it.'
    else
      # Write the new configuration file with the provided content
      content = request.body.read
      File.open(file_path, 'w') do |file|
        file.write(content)
      end
      'Configuration file created.'
    end
  end

  # Endpoint to update an existing configuration file
  put '/config/:filename' do
    file_path = File.join(settings.config_dir, params[:filename])
    if File.exist?(file_path)
      # Write the updated configuration file with the provided content
      content = request.body.read
      File.open(file_path, 'w') do |file|
        file.write(content)
      end
      'Configuration file updated.'
    else
      status 404
      'Configuration file not found. Use POST to create it.'
    end
  end

  # Endpoint to delete a configuration file
  delete '/config/:filename' do
    file_path = File.join(settings.config_dir, params[:filename])
    if File.exist?(file_path)
      # Delete the file
      File.delete(file_path)
      'Configuration file deleted.'
    else
      status 404
      'Configuration file not found.'
    end
  end

end
