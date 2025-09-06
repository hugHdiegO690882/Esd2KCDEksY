# 代码生成时间: 2025-09-06 12:00:03
# 数据库配置
DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://localhost/my_database')

# 日志配置
configure :production do
  enable :logging
  logger = Logger.new(File.join(settings.root, 'log', 'production.log'))
  logger.level = Logger::INFO
  set :logging, logger
end

# Sinatra路由定义
get '/' do
  "Migration Tool Home"
end

# 执行迁移操作
def migrate
  # 检查迁移文件是否存在
  migration_file = File.join(settings.root, 'db', 'migrations', 'current_version.sql')
  if File.exist?(migration_file)
    # 执行迁移SQL文件
    DB.run(File.read(migration_file))
    return "Migration successful"
  else
    # 处理迁移文件不存在的情况
    return "Migration file not found"
  end
rescue => e
  # 错误处理
  return "An error occurred during migration: #{e.message}"
end

# 执行迁移的路由
get '/migrate' do
  result = migrate
  return result
end

# 回滚迁移操作
def rollback
  # 检查回滚文件是否存在
  rollback_file = File.join(settings.root, 'db', 'migrations', 'rollback.sql')
  if File.exist?(rollback_file)
    # 执行回滚SQL文件
    DB.run(File.read(rollback_file))
    return "Rollback successful"
  else
    # 处理回滚文件不存在的情况
    return "Rollback file not found"
  end
rescue => e
  # 错误处理
  return "An error occurred during rollback: #{e.message}"
end

# 执行回滚的路由
get '/rollback' do
  result = rollback
  return result
end

# 程序结束