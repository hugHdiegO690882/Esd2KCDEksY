# 代码生成时间: 2025-10-02 18:11:35
# 使用Sinatra框架实现的文件上传服务
require 'sinatra'
require 'fileutils'

# 设置文件上传的存储路径
UPLOAD_PATH = 'uploads/'

# 确保上传目录存在
FileUtils.mkdir_p(UPLOAD_PATH)

# 上传文件的处理
post '/upload' do
  # 获取上传的文件
  file = params[:file]
  # 检查是否上传了文件
  unless file
    status 400
    {
      'error' => 'No file uploaded'
    }.to_json
    return
  end

  # 保存文件
  begin
    filename = File.basename(file[:filename])
    filepath = File.join(UPLOAD_PATH, filename)
    File.open(filepath, 'wb') do |f|
      f.write(file[:tempfile].read)
    end
  rescue => e
    status 500
    {
      'error' => "Failed to save file: #{e.message}"
    }.to_json
    return
  end

  # 返回成功响应
  {
    'filename' => filename,
    'message' => 'File uploaded successfully'
  }.to_json
end
