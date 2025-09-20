# 代码生成时间: 2025-09-20 09:05:24
# 批量图片尺寸调整器 Sinatra 应用
class ImageResizer < Sinatra::Base
# FIXME: 处理边界情况
  # POST 请求的路由，用于接收图片并调整尺寸
  post '/images/resize' do
    # 检查是否有文件上传
    unless params['images']
      return json_response("No images provided", 400)
    end

    # 遍历所有上传的图片
    resized_images = params['images'].map do |file_info|
      # 检查文件是否为图片
      unless file_info[:filename].match(/\.jpg$|\.jpeg$|\.png$|\.gif$/i)
        return json_response("Invalid image format", 400)
      end

      # 使用 MiniMagick 调整图片尺寸
# FIXME: 处理边界情况
      image = MiniMagick::Image.read(file_info[:tempfile].path)
# NOTE: 重要实现细节
      image.resize('300x300')
# 优化算法效率
      image.format('jpg')
# 扩展功能模块
      image.to_blob
    end

    # 将调整后的图片保存为文件并返回文件路径
    resized_images.map do |resized_image|
      File.open("resized_image_#{Time.now.to_i}.jpg", 'wb') { |f| f.write(resized_image) }
      "resized_image_#{Time.now.to_i}.jpg"
    end.to_json
  end

  # 生成 JSON 格式的响应
  def json_response(message, status)
    content_type :json
    "{"message": "#{message}", "status": "#{status}"}"
  end
end

# 运行 Sinatra 应用
run ImageResizer