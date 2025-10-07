# 代码生成时间: 2025-10-08 02:42:24
# 配置文件管理器应用
class ConfigManagerApp < Sinatra::Application

  # 定义配置文件存储路径
  CONFIG_DIR = "./configs/"

  # 定义配置文件列表接口
  get '/config' do
    # 检查目录是否存在
    unless File.directory?(CONFIG_DIR)
      status 500
      return {error: 'Configuration directory not found'}.to_json
    end
    
    # 获取目录下所有文件
    configs = Dir.entries(CONFIG_DIR).select { |entry| File.file?(File.join(CONFIG_DIR, entry)) }
    status 200
    {configs: configs}.to_json
  end

  # 定义创建配置文件接口
  post '/config' do
    config_name = params['name']
    # 错误处理
    unless config_name && config_name.include?(".json")
      status 400
      return {error: 'Invalid configuration file name'}.to_json
    end
    
    config_path = File.join(CONFIG_DIR, config_name)
    # 检查文件是否已存在
    if File.exist?(config_path)
      status 409
      return {error: 'Configuration file already exists'}.to_json
    end
    
    # 创建空的配置文件
    File.write(config_path, '{}')
    status 201
    {message: 'Configuration file created'}.to_json
  end

  # 定义读取配置文件接口
  get '/config/:name' do |name|
    # 检查文件是否存在
    config_path = File.join(CONFIG_DIR, name)
    unless File.exist?(config_path)
      status 404
      return {error: 'Configuration file not found'}.to_json
    end
    
    # 读取配置文件内容
    content = File.read(config_path)
    status 200
    JSON.parse(content)
  end

  # 定义更新配置文件接口
  put '/config/:name' do |name|
    # 检查文件是否存在
    config_path = File.join(CONFIG_DIR, name)
    unless File.exist?(config_path)
      status 404
      return {error: 'Configuration file not found'}.to_json
    end
    
    # 更新配置文件内容
    new_content = params['content']
    unless new_content
      status 400
      return {error: 'Content is required'}.to_json
    end
    
    File.write(config_path, new_content)
    status 200
    {message: 'Configuration file updated'}.to_json
  end

  # 定义删除配置文件接口
  delete '/config/:name' do |name|
    # 检查文件是否存在
    config_path = File.join(CONFIG_DIR, name)
    unless File.exist?(config_path)
      status 404
      return {error: 'Configuration file not found'}.to_json
    end
    
    # 删除配置文件
    File.delete(config_path)
    status 200
    {message: 'Configuration file deleted'}.to_json
  end

end
