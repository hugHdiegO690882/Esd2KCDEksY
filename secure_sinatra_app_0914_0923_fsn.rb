# 代码生成时间: 2025-09-14 09:23:05
# 使用 ActiveRecord 来防止 SQL 注入
class MyApp < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  # 在 Sinatra 应用中设置数据库配置
  # 这里使用 SQLite 作为例子，你可以根据需要替换为 MySQL 或 PostgreSQL
  ActiveRecord::Base.establish_connection(
    adapter:  "sqlite3",
    database: "my_app.sqlite3"
  )

  # 定义 User 模型
  class User < ActiveRecord::Base
  end

  # 用于展示用户列表的路由
  get '/users' do
    # 使用 ActiveRecord 的 find 方法安全地查询所有用户
    @users = User.all
    erb :users
  end

  # 用户创建接口，防止 SQL 注入
  post '/users' do
    user_params = params[:user]
    # 使用 ActiveRecord 的 create 方法安全地创建用户
    if User.create(user_params)
      status 201
      "User created successfully."
    else
      status 400
      "Failed to create user."
    end
  end

  # 错误处理
  not_found do
    'This page could not be found.'
  end
end

# 使用 eRuby 模板来展示用户列表
__END__

@@users
<!DOCTYPE html>
<html>
<head>
  <title>User List</title>
</head>
<body>
  <h1>User List</h1>
  <ul>
    <% @users.each do |user| %>
      <li><%= user.name %> - <%= user.email %></li>
    <% end %>
  </ul>
</body>
</html>
