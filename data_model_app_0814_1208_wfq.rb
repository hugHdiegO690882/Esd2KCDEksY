# 代码生成时间: 2025-08-14 12:08:45
# 定义数据模型
class User < ActiveRecord::Base
  # 验证用户名和邮箱的唯一性
  validates :username, uniqueness: true
  validates :email, uniqueness: true

  # 可以添加更多用户相关的验证和方法
end

# 设置数据库连接
set :database, {adapter: "sqlite3", database: "users.sqlite3"}

# Sinatra 应用程序
class DataModelApp < Sinatra::Base
  # 索引页面，展示所有用户
  get '/' do
    @users = User.all
    erb :index
  end

  # 创建用户
  post '/users' do
    user = User.new(params[:user])
    if user.save
      redirect '/'
    else
      @error = user.errors.full_messages.first
      erb :new
    end
  end

  # 显示创建用户的表单
  get '/users/new' do
    erb :new
  end

  # 错误处理
  error ActiveRecord::RecordInvalid do
    @error = 'Invalid data, please check the fields.'
    erb :new
  end

  # 辅助视图方法
  helpers do
    # 将错误消息显示为列表
    def error_messages
      return '' unless @error
      "<ul class='error-messages'><li>#{@error}</li></ul>"
    end
  end
end

# 视图模板
__END__

@@index
<!DOCTYPE html>
<html>
<head>
  <title>User List</title>
</head>
<body>
  <h1>User List</h1>
  <ul>
    <% @users.each do |user| %>
      <li><%= user.username %> - <%= user.email %></li>
    <% end %>
  </ul>
  <a href="/users/new">Add New User</a>
</body>
</html>

@@new
<!DOCTYPE html>
<html>
<head>
  <title>Create User</title>
</head>
<body>
  <h1>Create User</h1>
  <form action="/users" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="user[username]"><br>
    <label for="email">Email:</label>
    <input type="text" id="email" name="user[email]"><br>
    <%= error_messages %>
    <input type="submit" value="Create User">
  </form>
</body>
</html>
