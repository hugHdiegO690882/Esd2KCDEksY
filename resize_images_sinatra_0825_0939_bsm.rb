# 代码生成时间: 2025-08-25 09:39:14
# 图片尺寸批量调整器
class ResizeImageApp < Sinatra::Base
  # 设置图片存储的目录
  set :image_dir, './public/images'
  
  # 设置允许跨域请求
  configure do
    enable :cross_origin
  end

  # GET请求，显示图片上传表单
  get '/' do
    "<html><body><form action='/upload' method='post' enctype='multipart/form-data'><input type='file' name='image' multiple><button type='submit'>Upload</button></form></body></html>"
  end

  # POST请求，处理图片上传和尺寸调整
  post '/upload' do
    # 检查文件是否存在
    unless params[:image]
      return status(400).json({ error: 'No file provided' })
    end
    
    # 获取上传文件的尺寸
    file = params[:image][:tempfile]
    original_image = MiniMagick::Image.read(file)
    original_width = original_image.width
    original_height = original_image.height

    # 设置新的尺寸，这里以50%的尺寸为例
    new_width = original_width * 0.5
    new_height = original_height * 0.5

    # 调整图片尺寸
    resized_image = MiniMagick::Image.read(file).resize("#{new_width}x#{new_height}!")
    resized_image.format('jpg')

    # 保存调整后的图片
    resized_image_path = "#{settings.image_dir}/#{params[:image][:filename]}"
    File.open(resized_image_path, 'wb') do |file|
      file.write(resized_image.to_blob)
    end

    # 返回操作结果
    {
      original_width: original_width,
      original_height: original_height,
      new_width: new_width,
      new_height: new_height,
      file_path: resized_image_path
    }.to_json
  end

  # 错误处理
  error do
    e = request.env['sinatra.error']
    "<html><body><h1>Internal Server Error</h1><p>#{e.message}</p></body></html>"
  end
end