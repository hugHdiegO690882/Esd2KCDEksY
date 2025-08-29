# 代码生成时间: 2025-08-29 08:30:02
# 定义根路径，用于存放上传的图片
UPLOAD_FOLDER = './uploads'

# 确保上传目录存在
Dir.mkdir(UPLOAD_FOLDER) unless Dir.exist?(UPLOAD_FOLDER)

# Sinatra 应用
class ImageResizerApp < Sinatra::Application
  # POST /resize 路由，用于接收图片并调整尺寸
  post '/resize' do
    # 读取上传的图片
    image = params[:file][:tempfile]
    target_width = params[:target_width].to_i
    target_height = params[:target_height].to_i
    
    # 错误处理：确保图片和目标尺寸都有效
    halt 400, json({error: 'Invalid image or target dimensions'}) unless image && target_width.positive? && target_height.positive?
    
    # 构建目标文件名
    target_filename = "#{UPLOAD_FOLDER}/#{params[:file][:filename]}"
    
    # 保存上传的图片
    File.open(target_filename, 'wb') { |f| f.write(image.read) }
    
    # 使用 MiniMagick 调整图片尺寸
    resized_image = MiniMagick::Image.new(target_filename) do |img|
      img.resize "#{target_width}x#{target_height}"
    end
    
    # 保存调整后的图片
    resized_filename = target_filename.sub(/\..+$/, '') + "_resized.#{resized_image.format}"
    resized_image.write(resized_filename)
    
    # 返回成功的响应和调整后的图片路径
    json({
      success: true,
      resized_image_path: resized_filename
    })
  end

  # GET / 路由，提供简单的使用文档
  get '/' do
    "<html><body><h1>Image Resizer Service</h1><p>Upload an image and specify target width and height to resize it.</p></body></html>"
  end
end

# 辅助函数，用于生成 JSON 响应
def json(data)
  "Content-Type: application/json" + "
" + JSON.pretty_generate(data)
end
