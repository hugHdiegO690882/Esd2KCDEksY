# 代码生成时间: 2025-09-05 05:09:11
# 解压缩文件的服务
class UnzipTool < Sinatra::Base

  # 路由：POST请求到/unzip，用于接收压缩文件并解压
  post '/unzip' do
    # 检查是否有文件上传
    unless params[:file]
      return json_error(400, 'No file provided')
    end

    # 保存上传的文件到临时目录
    tempfile = params[:file][:tempfile]
    file_name = params[:file][:filename]
    target_path = './uploads/' + file_name
    File.open(target_path, 'wb') { |f| f.write(tempfile.read) }

    # 解压文件
    begin
      Zip::File.open(target_path) do |zip_file|
        # 创建解压目录
        extract_path = './extracted/' + File.basename(file_name, File.extname(file_name))
        FileUtils.mkdir_p(extract_path)

        # 解压所有文件到指定目录
        zip_file.each { |entry|
          entry.extract("#{extract_path}/#{entry.name}") unless entry.directory?
        }
      end
    rescue Zip::Error => e
      return json_error(500, 'Failed to unzip the file: ' + e.message)
    ensure
      # 删除临时上传的压缩文件
      File.delete(target_path) if File.exist?(target_path)
    end

    # 返回成功消息和解压后的文件路径
    json_success(200, "File extracted to #{extract_path}")
  end

  private

  # 打印JSON格式的错误消息
  def json_error(status, message)
    content_type :json
    {
      status: status,
      error: message
    }.to_json
  end

  # 打印JSON格式的成功消息
  def json_success(status, message)
    content_type :json
    {
      status: status,
      message: message
    }.to_json
  end
end

# 确保有uploads和extracted文件夹存在
FileUtils.mkdir_p('./uploads')
FileUtils.mkdir_p('./extracted')

# 运行Sinatra应用
run! if app_file == $0
