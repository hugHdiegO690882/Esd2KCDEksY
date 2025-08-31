# 代码生成时间: 2025-08-31 17:55:07
# 图片尺寸批量调整器的Sinatra应用
class ImageResizer < Sinatra::Base

  # 设置上传文件的大小限制
  configure do
    set :upload_limit, 1024 * 1024 * 5 # 5MB
  end

  # GET请求首页
  get '/' do
    "Welcome to the Image Resizer!"
  end

  # POST请求处理文件上传和尺寸调整
  post '/upload' do
    # 错误处理: 检查是否有文件上传
    if params[:file].empty?
      halt 400, {
        'error' => "No file uploaded"
      }.to_json
    end

    # 读取上传的文件
    uploaded_file = params[:file][:tempfile]
    filename = params[:file][:filename]

    # 错误处理: 检查文件类型
    unless ['image/jpeg', 'image/png'].include?(params[:file][:type])
      halt 400, {
        'error' => "Unsupported file type"
      }.to_json
    end

    # 生成新的图片文件名
    new_filename = "resized_#{filename}"

    # 使用MiniMagick调整图片尺寸
    begin
      image = MiniMagick::Image.read(uploaded_file)
      # 假设我们要将图片调整为宽度为800px
      image.resize '800x800'
      image.write new_filename
    rescue MiniMagick::Error => e
      # 错误处理: 捕获MiniMagick的错误
      halt 500, {
        'error' => e.message
      }.to_json
    end

    # 返回成功信息和新文件的URL
    {
      'message' => "Image resized successfully",
      'new_filename' => new_filename,
      'url' => "/uploads/#{new_filename}"
    }.to_json
  end

  # 静态文件服务，用于提供调整后的图片下载
  get '/uploads/*' do
    send_file File.join(settings.public_folder, 'uploads', params[:splat].first)
  end

end

# 运行Sinatra应用
run ImageResizer
