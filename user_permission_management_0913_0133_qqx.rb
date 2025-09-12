# 代码生成时间: 2025-09-13 01:33:37
# 用户权限管理系统
# 使用Sinatra框架构建的简单RESTful API

# 数据库配置
DB = SQLite3::Database.new 'users.db'
DB.execute 'CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  role TEXT NOT NULL
)'

# 用户模型
class User
  attr_accessor :id, :username, :password, :role

  # 创建新用户
  def initialize(username, password, role)
    @username = username
    @password = password
    @role = role
  end

  # 保存用户到数据库
  def save
    DB.execute 'INSERT INTO users (username, password, role) VALUES (?, ?, ?)',
      [@username, @password, @role]
    @id = DB.last_insert_row_id
  end

  # 通过用户名查找用户
  def self.find_by_username(username)
    user = DB.execute 'SELECT * FROM users WHERE username = ?', [username]
    user.empty? ? nil : User.new(*user[0])
  end
end

# 路由定义
get '/' do
  'Welcome to the User Permission Management System!'
end

# 用户列表
get '/users' do
  content_type :json
  DB.execute 'SELECT * FROM users'
    .map { |row| User.new(*row).attributes }.to_json
end

# 创建新用户
post '/users' do
  content_type :json
  user_params = JSON.parse(request.body.read)
  user = User.new(user_params['username'], user_params['password'], user_params['role'])
  user.save
  { id: user.id, username: user.username, role: user.role }.to_json
rescue SQLite3::Exception => e
  { error: e.message }.to_json
end

# 用户权限检查中间件
before '/users/*' do
  unless authorized?
    halt 401, { error: 'Unauthorized' }.to_json
  end
end

# 检查是否授权
def authorized?
  request.env['warden'].authenticate
end

# 使用Warden进行身份验证
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = self
end

# 用户登录
post '/login' do
  content_type :json
  username = params['username']
  password = params['password']

  user = User.find_by_username(username)
  if user && user.password == password
    request.env['warden'].set_user user
    { message: 'Logged in successfully' }.to_json
  else
    halt 401, { error: 'Invalid username or password' }.to_json
  end
rescue SQLite3::Exception => e
  halt 500, { error: e.message }.to_json
end

# 用户登出
delete '/logout' do
  content_type :json
  request.env['warden].logout
  { message: 'Logged out successfully' }.to_json
end

# 错误处理
error do
  e = request.env['sinatra.error']
  status 500
  { error: e.message }.to_json
end
