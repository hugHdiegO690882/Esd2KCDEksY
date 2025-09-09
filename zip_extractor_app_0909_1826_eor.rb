# 代码生成时间: 2025-09-09 18:26:16
# 使用 Sinatra 框架创建一个简单的解压文件的 Web 应用
class ZipExtractorApp < Sinatra::Application
  # 设置解压文件的存储路径
  UPLOAD_FOLDER = 'uploads'
  UNZIP_FOLDER = 'unzipped'

  # POST /extract - 提交压缩文件并解压
  post '/extract' do
    # 检查是否有文件被上传
    if params[:file] && params[:file][:tempfile]
      file = params[:file][:tempfile]

      # 保存上传的文件
      original_filename = params[:file][:filename]
      target_path = File.join(UPLOAD_FOLDER, original_filename)
      File.open(target_path, 'wb') { |f| f.write(file.read) }

      # 解压文件
      unzip_path = File.join(UNZIP_FOLDER, File.basename(original_filename, File.extname(original_filename)))
      unzip_options = { :consume => true } # 移除源文件
      begin
        Zip::File.open(file) do |zip_file|
          zip_file.extract_all(unzip_path, unzip_options)
        end
      rescue Zip::Error => e
        # 错误处理 - 文件不是有效的压缩文件
        return json_error(404, "Invalid zip file: #{e.message}")
      end

      # 返回解压成功的信息
      json_success(200, "File extracted to: #{unzip_path}")
    else
      # 错误处理 - 没有文件被上传
      json_error(400, 'No file uploaded')
    end
  end

  private

  # 返回 JSON 格式的成功响应
  def json_success(status, message)
    content_type :json
    {
      status: status,
      message: message
    }.to_json
  end

  # 返回 JSON 格式的错误响应
  def json_error(status, message)
    content_type :json
    {
      status: status,
      error: message
    }.to_json
  end

  # 确保上传路径存在
  not_found do
    unless File.directory?(UPLOAD_FOLDER)
      FileUtils.mkdir_p(UPLOAD_FOLDER)
    end
    unless File.directory?(UNZIP_FOLDER)
      FileUtils.mkdir_p(UNZIP_FOLDER)
    end
  end
end