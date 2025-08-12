# 代码生成时间: 2025-08-12 21:21:52
# 批量文件重命名工具
class BatchFileRenamer < Sinatra::Application
  # POST请求处理文件上传和重命名
  post '/rename' do
    # 检查文件是否存在
    unless params[:files] && params[:files][:tempfile]
      return status 400
      return {'error' => 'No file provided'}.to_json
    end

    # 获取上传的文件和目标文件名
    uploaded_file = params[:files][:tempfile]
    new_filename = params[:new_filename]

    # 检查新文件名是否合法
    unless new_filename && new_filename.is_a?(String) && new_filename.match(/\A[a-zA-Z0-9_]+\z/)
      return status 400
      return {'error' => 'Invalid filename'}.to_json
    end

    # 构建新文件的完整路径
    new_path = File.join(settings.public_folder, new_filename)

    # 复制文件，并重命名
    begin
      FileUtils.cp(uploaded_file.path, new_path)
    rescue => e
      return status 500
      return {'error' => 'Failed to rename file', 'message' => e.message}.to_json
    end

    # 返回成功消息
    {'message' => 'File renamed successfully', 'filename' => new_filename}.to_json
  end

  # 启动Sinatra服务器
  run! if app_file == $0
end