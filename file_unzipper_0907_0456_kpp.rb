# 代码生成时间: 2025-09-07 04:56:17
# 文件解压工具
class FileUnzipper < Sinatra::Base

  # 提供解压文件的接口
  get '/unzip/:filename' do
    # 从URL参数获取文件名
    filename = params[:filename]

    # 检查文件是否存在
    unless File.exist?(filename)
      halt 404, {
        "error": "File not found"
      }.to_json
    end

    # 尝试解压文件
    begin
      # 确保文件是一个ZIP文件
      if File.extname(filename).downcase == '.zip'
        # 创建解压后的文件夹路径
        output_dir = "unzipped/#{File.basename(filename, '.zip')}"
        # 解压文件
        Zip::File.open(filename) do |zip_file|
          zip_file.each do |f|
            f_path = File.join(output_dir, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          end
        end
        # 返回解压后的文件夹路径
        {
          "message": "File extracted successfully",
          "path": output_dir
        }.to_json
      else
        halt 400, {"error": "Invalid file type, only .zip is supported"}.to_json
      end
    rescue Zip::Error => e
      halt 500, {"error": "Failed to extract file: #{e.message}"}.to_json
    end
  end

  # 静态文件服务，用于提供解压后的文件访问
  get '/unzipped/*' do
    # 设置静态文件根目录
    set :public_folder, File.join(settings.root, 'unzipped')
    # 调用Sinatra的静态文件服务方法
    File.exist?(params[:splat].first) ? send_file(params[:splat].first) : halt(404)
  end

end

# 设置端口和启动服务器
run! if app_file == $0