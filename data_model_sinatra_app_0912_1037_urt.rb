# 代码生成时间: 2025-09-12 10:37:43
# 数据库配置
configure do
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'your_database.sqlite'
  )
end

# 模型定义
class User < ActiveRecord::Base
  # 确保用户模型的表存在
  before do
    ActiveRecord::Base.connection.create_table(:users) do
      |t|
      t.column :username, :string
      t.column :email, :string
      t.column :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end unless ActiveRecord::Base.connection.table_exists?(:users)
  end

  # 添加错误处理
  rescue_from(ActiveRecord::RecordInvalid) do
    'User could not be saved.'
  end
end

# 设置路由
get '/' do
  'Hello World!'
end

g