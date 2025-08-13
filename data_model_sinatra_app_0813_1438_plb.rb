# 代码生成时间: 2025-08-13 14:38:49
# 数据库配置
configure :development do
  ActiveRecord::Base.establish_connection(
    adapter:  'sqlite3',
    database: 'development.sqlite3'
  )
end

# 数据模型
class User < ActiveRecord::Base
  # 用户模型，包含基本的用户名和邮箱字段
end

# 路由
get '/' do
  # 列出所有用户
  @users = User.all
  erb :index
end

get '/users/new' do
  # 创建一个新的用户表单
  erb :new
end

post '/users' do
  # 创建新用户
  @user = User.new(params[:user])
  if @user.save
    redirect '/'
  else
    erb :new
  end
end

__END__

@@index
<!doctype html>
<html>
<head>
  <title>Users</title>
</head>
<body>
  <h1>Users</h1>
  <ul>
    <% @users.each do |user| %>
      <li><%= user.id %> - <%= user.username %>
        <a href="/users/destroy/<%= user.id %>">Destroy</a>
        <a href="/users/edit/<%= user.id %>">Edit</a>
      </li>
    <% end %>
  </ul>
  <a href="/users/new">New User</a>
</body>
</html>

@@new
<!doctype html>
<html>
<head>
  <title>New User</title>
</head>
<body>
  <h1>New User</h1>
  <form action="/users" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="user[username]"><br>
    <label for="email">Email:</label>
    <input type="email" id="email" name="user[email]"><br>
    <input type="submit" value="Create User">
  </form>
</body>
</html>