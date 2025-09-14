# 代码生成时间: 2025-09-14 15:03:45
# 使用ActiveRecord方便操作数据库
set :database, {adapter: 'sqlite3', database: 'app.db'}

# 用户模型
class User < ActiveRecord::Base
  # 验证用户名和密码的存在性
  validates :username, presence: true
  validates :password, presence: true
end

# 设置访问权限的中间件
class AccessControl
  def initialize(app)
    @app = app
  end

  def call(env)
    # 从请求的session中获取用户
    user = env['warden'].user(session: env['rack.session'])
    # 如果用户不存在，重定向到登录页面
    unless user
      redirect '/login'
    else
      @app.call(env)
    end
  end
end

# 使用Warden进行身份验证
use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = self
end

# 配置Warden策略
Warden::Strategies.add(:password) do
  def valid?
    params['username'] && params['password']
  end

  def authenticate!
    user = User.find_by(username: params['username'])
    throw(:warden, {message: 'Invalid credentials'}) unless user && user.password == params['password']
    success!(user)
  end
end

# 设置访问控制中间件
use AccessControl

# 登录页面
get '/login' do
  erb :login
end

# 登录逻辑
post '/login' do
  env['warden'].authenticate!(scope: :user)
  redirect '/'
rescue Warden::Strategies::FailedAttempt
  erb :login_error
end

# 登出逻辑
get '/logout' do
  env['warden'].logout
  redirect '/login'
end

# 受保护的首页
get '/' do
  # 用户必须通过身份验证才能访问这个页面
  "Welcome, #{current_user.username}!"
end

# 登录错误页面
get '/login_error' do
  erb :login_error
end

# 设置视图和公共文件夹
set :views, __dir__ + '/views'
set :public_folder, __dir__ + '/public'

# 定义帮助方法获取当前用户
helpers do
  def current_user
    env['warden'].user
  end
end