# 代码生成时间: 2025-08-15 12:02:59
# 用户权限管理系统
class UserRoleManagement < Sinatra::Base

  # 数据库设置
  DB = Sequel.sqlite('user_roles.db')
  DB.extension :migration

  # 迁移数据库以创建用户表和角色表
  Sequel::Migrator.run(DB, 'migrations')

  # 用户模型
  class User < Sequel::Model(DB)
    many_to_many :roles
  end

  # 角色模型
  class Role < Sequel::Model(DB)
    many_to_many :users
  end

  # 路由设置
  get('/') do
    "Welcome to the User Role Management System"
  end

  # 获取所有用户和他们的权限
  get('/users') do
    @users = User.all
    erb :users
  end

  # 获取单个用户及其权限
  get('/users/:id') do
    @user = User.find(params[:id])
    if @user
      erb :user
    else
      halt 404, 'User not found'
    end
  end

  # 创建新用户
  post('/users') do
    user = User.create(username: params['username'], password: params['password'])
    if user.valid?
      "User created successfully."
    else
      halt 400, "Failed to create user: #{user.errors.full_messages.to_sentence}"
    end
  end

  # 更新用户权限
  put('/users/:id/roles') do
    user = User.find(params[:id])
    if user
      # 清除旧的角色关联
      user.roles_dataset.delete
      # 添加新的角色
      params['roles'].each do |role_name|
        role = Role.find_or_create(name: role_name)
        user.add_role(role)
      end
      "User roles updated successfully."
    else
      halt 404, 'User not found'
    end
  end

  # 错误处理
  error do
    erb :error, locals: { error: env['sinatra.error'] }
  end

end

# 数据库迁移文件
# migrations/001_create_users.rb
Sequel.migration do
  up do
    create_table?(:users) do
      primary_key :id
      String :username, null: false, unique: true
      String :password, null: false
    end
  end

  down do
    drop_table?(:users)
  end
end

# migrations/002_create_roles.rb
Sequel.migration do
  up do
    create_table?(:roles) do
      primary_key :id
      String :name, null: false, unique: true
    end
  end

  down do
    drop_table?(:roles)
  end
end

# migrations/003_create_user_roles_join_table.rb
Sequel.migration do
  up do
    create_table?(:user_roles) do
      foreign_key :user_id, :users, null: false, on_delete: :cascade
      foreign_key :role_id, :roles, null: false, on_delete: :cascade
      primary_key [:user_id, :role_id]
    end
  end

  down do
    drop_table?(:user_roles)
  end
end

# views/users.erb
<ul>
<% @users.each do |user| %>
  <li><%= user.username %> - <%= user.roles.map(&:name).join(', ') %></li>
<% end %>
</ul>

# views/user.erb
<h1><%= @user.username %></h1>
<p>Roles: <%= @user.roles.map(&:name).join(', ') %></p>

# views/error.erb
<h1>Error <%= env['sinatra.error'].class %>: <%= env['sinatra.error'].message %></h1>
<p><%= env['sinatra.error'].backtrace.join('<br/>') %></p>