# 代码生成时间: 2025-09-11 07:44:25
# FolderOrganizer is a Sinatra application that helps to organize folders.
class FolderOrganizer < Sinatra::Base

  # Root path for the application
  get '/' do
    "Welcome to the Folder Organizer."
  end

  # POST endpoint to organize a folder
  post '/organize' do
    # Retrieve the folder path from the request parameters
    folder_path = params['folder_path']

    # Check if the folder path is provided
    if folder_path.nil? || folder_path.empty?
      return_error('Folder path is required.')
    end

    # Check if the provided path is a directory
    unless File.directory?(folder_path)
      return_error('The provided path is not a directory.')
    end

    # Organize the folder by sorting files and subdirectories
    begin
      organize_folder(folder_path)
      "Folder organized successfully."
    rescue StandardError => e
      return_error("An error occurred: #{e.message}")
    end
  end

  private

  # Organize a folder by sorting files and subdirectories
  def organize_folder(folder_path)
    # Get all items in the folder
    items = Dir.entries(folder_path) - ['.', '..']

    # Sort items into files and directories
    files = items.select { |item| File.file?(File.join(folder_path, item)) }.sort
    directories = items.select { |item| File.directory?(File.join(folder_path, item)) }.sort

    # Move files to the top of the directory list
    items = files + directories

    # Move items to their new positions
    items.each_with_index do |item, index|
      FileUtils.mv(File.join(folder_path, item), File.join(folder_path, "#{index}_#{item}"))
    # Rename files and directories to a sorted order
      FileUtils.mv(File.join(folder_path, "#{index}_#{item}"), File.join(folder_path, item))
    end
  end

  # Helper method to return error messages in JSON format
  def return_error(message)
    content_type :json
    { error: message }.to_json
  end

end

# Run the Sinatra application
run! if app_file == $0