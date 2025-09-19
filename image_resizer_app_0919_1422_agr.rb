# 代码生成时间: 2025-09-19 14:22:27
# 图片尺寸批量调整器的Sinatra应用程序
class ImageResizerApp < Sinatra::Base

  # 处理POST请求以上传图片并接收新的尺寸参数
  post '/resize' do
    # 检查是否有文件上传
    unless params[:images]
      status 400
      return { error: 'No images were uploaded.' }.to_json
    end

    # 遍历上传的图片文件
    params[:images].each do |image|
      filename = image[:filename]
      tempfile = image[:tempfile]
      target_width = params[:width].to_i
      target_height = params[:height].to_i

      # 使用MiniMagick进行图片尺寸调整
      begin
        resized_image = MiniMagick::Image.read(tempfile).resize "#{target_width}x#{target_height}"
        resized_image_path = "public/resized/#{filename}"
        resized_image.write resized_image_path
      rescue MiniMagick::Error => e
        # 错误处理：如果图片处理失败，记录错误并跳过当前图片
        $stderr.puts "Error resizing #{filename}: #{e.message}"
        next
      end
    end

    # 返回成功信息和调整后的图片路径
    { success: 'Images resized successfully.', resized_images: Dir.glob('public/resized/*') }.to_json
  end

end

# 启动Sinatra服务器
run! if app_file == $0