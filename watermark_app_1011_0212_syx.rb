# 代码生成时间: 2025-10-11 02:12:21
# 水印应用
# 这个Sinatra应用提供了数字水印功能。

require 'sinatra'
require 'rmagick'
require 'pry'
require 'json'

# 定义路由
get '/' do
  erb :index
end

# 上传并添加水印的路由
post '/add_watermark' do
  # 错误处理
  if params[:file].nil? || params[:watermark_text].nil?
    halt 400, {
      'Content-Type' => 'application/json',
      'error' => 'Missing file or watermark text'
    }.to_json
  end
  
  # 读取上传的图片
  image_path = params[:file][:tempfile].path
  image = Magick::Image.read(image_path).first
  
  # 添加水印
  watermark = Magick::Draw.new
  watermark.annotate(image, Magick::CenterGravity, "", params[:watermark_text]) do
    self.pointsize = 24
    self.fill = 'gray'
  end
  
  # 保存添加了水印的图片
  watermark_image_path = './public/watermarked_images/' + File.basename(params[:file][:filename])
  image.write(watermark_image_path)
  
  # 返回结果和图片URL
  status 201
  {
    success: true,
    image_url: watermark_image_path
  }.to_json
end

# 定义Erb模板
__END__

@@ index
<!DOCTYPE html>
<html>
<head>
  <title>Watermark App</title>
</head>
<body>
  <h1>Upload an image and add watermark</h1>
  <form action='/add_watermark' method='post' enctype='multipart/form-data'>
    <input type='file' name='file'>
    <input type='text' name='watermark_text' placeholder='Enter watermark text'>
    <input type='submit' value='Add Watermark'>
  </form>
</body>
</html>
