# 代码生成时间: 2025-08-21 19:07:26
# 数据库配置
configure do
  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :database => 'sinatra_app',
    :username => 'sinatra_user',
    :password => 'sinatra123',
    :host => 'localhost',
    :min_messages => 'WARNING'
  )
end

# 定义User模型
class User < ActiveRecord::Base
  # 验证邮箱格式
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # 用户名唯一性校验
  validates :username, uniqueness: true
end

# 路由设计
get '/' do
  "Welcome to our API"
end

get '/users' do
  # 获取所有用户信息
  User.all.to_json
end

post '/users' do
  # 创建新用户
  user_params = JSON.parse(request.body.read)
  user = User.new(user_params)
  if user.save
    { id: user.id, username: user.username, email: user.email }.to_json
  else
    # 错误处理
    status 400
    { error: user.errors.full_messages }.to_json
  end
end

# 错误处理
not_found do
  { error: 'Not found' }.to_json
end
error do
  e = request.env['sinatra.error']
  status 500
  { error: e.message }.to_json
end