# 代码生成时间: 2025-09-06 07:14:34
# 解压工具的 Sinatra 应用
class UnzipTool < Sinatra::Application
  # 设置解压文件的目录
  UNZIP_DIR = 'tmp/unzipped_files'
  
  configure do
    # 确保解压目录存在
    FileUtils.mkdir_p(UNZIP_DIR)
  end

  # 根路由，用于上传文件
  get '/' do
    erb :upload
  end

  # 上传并解压文件的 POST 路由
  post '/upload' do
    # 检查上传的文件
    if params[:file]
      file = params[:file][:tempfile]
      filename = params[:file][:filename]
      target_dir = File.join(UNZIP_DIR, File.basename(filename, '.*'))
      begin
        # 创建目标目录
        FileUtils.mkdir_p(target_dir)
        
        # 解压文件
        Zip::File.open(file) do |zip_file|
          zip_file.each do |entry|
            entry.extract(File.join(target_dir, entry.name))
          end
        end
        
        # 返回解压成功的信息
        "File #{filename} has been successfully unzipped to #{target_dir}/"
      rescue Zip::Error => e
        # 处理压缩文件错误
        "Error: #{e.message}"
      rescue => e
        # 处理其他错误
        "Error: #{e.message}"
      end
    else
      # 如果没有文件上传，返回错误信息
      "Please upload a file."
    end
  end

  # 路由，用于清理临时文件
  post '/cleanup' do
    FileUtils.rm_rf(UNZIP_DIR)
    "Temporary files have been cleaned up."
  end
end

# 辅助方法，用于在错误页面显示错误信息
helpers do
  def error_message(e)
    "<p style='color: red;'>#{e}</p>"
  end
end

# 辅助模板，用于上传文件页面
__END__

@@upload
<!DOCTYPE html>
<html>
<head>
  <title>Unzip Tool</title>
</head>
<body>
  <h1>Upload a ZIP file to be unzipped</h1>
  <form action='/upload' method='post' enctype='multipart/form-data'>
    <input type='file' name='file'>
    <input type='submit' value='Unzip File'>
  </form>
  <% if @error %>
    <%= error_message(@error) %>
  <% end %>
</body>
</html>