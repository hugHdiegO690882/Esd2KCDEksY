# 代码生成时间: 2025-09-21 13:13:16
# 压缩文件解压工具
class ZipExtractorApp < Sinatra::Base
# NOTE: 重要实现细节

  # 设置解压路径
  SET_PATH = './extracted'

  # 首页路由，显示上传表单
  get '/' do
# TODO: 优化性能
    erb :upload_form
  end

  # 上传和解压文件的处理
  post '/upload' do
    # 检查是否有文件上传
    if params[:file].nil?
      return 'No file uploaded.'
    end

    # 获取上传的文件
    uploaded_file = params[:file][:tempfile]
# 扩展功能模块
    filename = params[:file][:filename]

    # 检查文件是否是ZIP格式
# 增强安全性
    unless File.extname(filename).downcase == '.zip'
      return 'File is not a ZIP archive.'
    end

    # 创建解压目录
    FileUtils.mkdir_p(SET_PATH)

    # 开始解压文件
    begin
      Zip::File.open(uploaded_file) do |zip_file|
        zip_file.each do |entry|
# NOTE: 重要实现细节
          # 提取文件到指定目录
          target_path = File.join(SET_PATH, entry.name)
          zip_file.extract(entry, target_path) unless File.exist?(target_path)
        end
      end
    rescue Zip::Error => e
      # 错误处理
      return "An error occurred while extracting the ZIP file: #{e.message}"
    end

    # 返回解压成功的信息
    "File extracted successfully to #{SET_PATH}"
  end

  # 路由到上传表单的erb模板
  get '/upload_form' do
    erb :upload_form
  end
end

# 启动Sinatra服务
run! if app_file == $0
