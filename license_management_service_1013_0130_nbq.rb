# 代码生成时间: 2025-10-13 01:30:25
# LicenseManagementService is a Sinatra-based application
# that provides a simple license management system.
class LicenseManagementService < Sinatra::Base

  # Endpoint to get all licenses
  get '/licenses' do
    # Fetch all licenses from the data store
    licenses = License.all
    # Return the licenses in JSON format
    content_type :json
    licenses.to_json
  end

  # Endpoint to create a new license
  post '/licenses' do
    # Parse the incoming JSON data
    data = JSON.parse(request.body.read)
    # Validate the data
    unless data.has_key?('name') && data.has_key?('expiration_date')
      status 400
      return { error: 'Missing required fields' }.to_json
    end
    # Create a new license
    license = License.create(name: data['name'], expiration_date: data['expiration_date'])
    # Return the created license in JSON format
    content_type :json
    license.to_json
  end

  # Endpoint to update an existing license
  put '/licenses/:id' do
    # Parse the ID from the URL and the incoming JSON data
    id = params['id']
    data = JSON.parse(request.body.read)
    # Find the license by ID and update it
    license = License.find(id)
    if license
      license.update(name: data['name'], expiration_date: data['expiration_date'])
      # Return the updated license in JSON format
      content_type :json
      license.to_json
    else
      status 404
      { error: 'License not found' }.to_json
    end
  end

  # Endpoint to delete a license
  delete '/licenses/:id' do
    # Parse the ID from the URL
    id = params['id']
    # Find the license by ID and delete it
    license = License.find(id)
    if license
      license.destroy
      status 204
    else
      status 404
      { error: 'License not found' }.to_json
    end
  end

  # Error handling for 404
  not_found do
    content_type :json
    { error: 'Not Found' }.to_json
  end

end

# License model for the database
class License
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :expiration_date, Date

  # Find all licenses
  def self.all
    all(:order => :id)
  end

  # Find a license by ID
  def self.find(id)
    get(id)
  end

  # Create a new license
  def self.create(attributes)
    create(attributes)
  end
end

# Run the Sinatra application
run! if app_file == $0