# 代码生成时间: 2025-09-22 07:53:24
# UserLoginSystem class for handling user login logic
class UserLoginSystem
  attr_accessor :users
  
  # Initialize the system with a users hash
  def initialize
    @users = {}
  end

  # Add a user to the system
  def add_user(username, password)
    @users[username] = password
  end

  # Check if a user exists in the system
  def user_exists?(username)
    !@users[username].nil?
  end

  # Validate a user's credentials
  def validate_credentials(username, password)
    user_exists?(username) && @users[username] == password
  end
end

# Set up the Sinatra application
get '/' do
  "Welcome to the User Login System"
end

post '/login' do
  # Parse the JSON request body
  request.body.rewind
  credentials = JSON.parse(request.body.read)

  # Extract username and password from the request
  username = credentials['username']
  password = credentials['password']

  # Instantiate the UserLoginSystem
  login_system = UserLoginSystem.new

  # Add test users (for demonstration purposes)
  login_system.add_user('user1', 'password1')
  login_system.add_user('admin', 'admin123')

  # Check if the user exists and validate credentials
  if login_system.user_exists?(username) && login_system.validate_credentials(username, password)
    "Login successful"
  else
    "Login failed"
  end
end
