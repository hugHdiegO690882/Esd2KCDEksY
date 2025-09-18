# 代码生成时间: 2025-09-18 15:51:59
# 使用 Sinatra 创建一个简单的 Web 应用
class ValidateUrlApp < Sinatra::Base
  # 设置一个路由来处理 URL 验证请求
  get '/validate' do
    # 获取查询参数中的 'url'
    url_to_validate = params['url']

    # 错误处理：检查 URL 是否存在
    halt 400, {
      'Content-Type' => 'application/json',
      message: 'URL parameter is required.'
    }.to_json unless url_to_validate

    # 验证 URL 的格式是否正确
    begin
      uri = URI.parse(url_to_validate)
    rescue URI::InvalidURIError
      # 如果 URL 格式不正确，返回错误信息
      halt 400, {
        'Content-Type' => 'application/json',
        message: 'Invalid URL format.'
      }.to_json
    end

    # 检查 URL 是否可访问
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request_head(uri.path)
    end

    # 根据 HTTP 响应码返回结果
    if response.is_a?(Net::HTTPSuccess)
      "{"filename": "validate_url.rb", "code": "The URL is valid and accessible."}"
    else
      "{"filename": "validate_url.rb", "code": "The URL is valid but not accessible."}"
    end
  end
end

# 设置运行端口和主机
set :port, 4567
set :bind, '0.0.0.0'

# 启动 Sinatra 应用
run! if app_file == $0