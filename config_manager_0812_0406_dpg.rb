# 代码生成时间: 2025-08-12 04:06:13
# 配置文件管理器
# 该程序通过SINATRA框架提供配置文件的CRUD操作。
class ConfigManager < Sinatra::Base

  # 配置文件的存储路径
  CONFIG_PATH = 'config_files/'

  # 设置静态文件目录
  set :public_folder, CONFIG_PATH

  # 确保配置文件目录存在
  not_found do
    if File.exist?(CONFIG_PATH)
      'Configuration files directory exists.'
    else
      'Configuration files directory does not exist.'
    end
  end

  # GET / - 列出所有配置文件
  get '/' do
    # 检查目录是否存在
    unless File.directory?(CONFIG_PATH)
      return 'Configuration directory does not exist.'
    end
    # 列出所有文件
    Dir.entries(CONFIG_PATH).map { |file| "#{file}
" }.join.chomp
  end

  # POST / - 上传配置文件
  post '/' do
    # 检查文件是否上传
    if params[:file]
      # 保存文件到配置目录
      file = params[:file][:tempfile]
      filename = params[:file][:filename]
      File.open(File.join(CONFIG_PATH, filename), 'wb') do |f|
        f.write(file.read)
      end
      "File uploaded: #{filename}"
    else
      'No file uploaded.'
    end
  end

  # GET /:name - 获取单个配置文件内容
  get '/:name' do |name|
    # 检查文件是否存在
    unless File.exist?(File.join(CONFIG_PATH, name))
      return 'File not found.'
    end
    # 返回文件内容
    content_type 'application/octet-stream'
    attachment name
    File.read(File.join(CONFIG_PATH, name))
  end

  # DELETE /:name - 删除单个配置文件
  delete '/:name' do |name|
    # 检查文件是否存在
    unless File.exist?(File.join(CONFIG_PATH, name))
      return 'File not found.'
    end
    # 删除文件
    File.delete(File.join(CONFIG_PATH, name))
    "File deleted: #{name}"
  end

  # PUT /:name - 更新单个配置文件内容
  put '/:name' do |name|
    # 检查文件是否上传
    if params[:file]
      file = params[:file][:tempfile]
      # 保存文件到配置目录
      File.open(File.join(CONFIG_PATH, name), 'wb') do |f|
        f.write(file.read)
      end
      "File updated: #{name}"
    else
      'No file uploaded.'
    end
  end

end

# 运行SINATRA应用
run! if __FILE__ == $0