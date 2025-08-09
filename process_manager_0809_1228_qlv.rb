# 代码生成时间: 2025-08-09 12:28:16
# 进程管理器
class ProcessManager < Sinatra::Base

  # 列出所有进程
  get '/processes' do
    # 获取所有进程信息
    processes = `ps aux`
    # 返回进程信息的JSON格式
    content_type :json
    processes.to_json
  end

  # 启动一个新的进程
  post '/start' do
    request.body.rewind  # 重置请求体
    process_info = JSON.parse(request.body.read)

    # 检查进程命令是否提供
    if process_info['command'].nil?
      status 400
      return { error: 'Missing command' }.to_json
    end

    # 启动进程
    system(process_info['command'])
    status 201
    { message: 'Process started' }.to_json
  end

  # 停止一个进程
  delete '/stop/:pid' do |pid|
    # 停止指定的进程ID
    system("kill -9 #{pid}")
    status 200
    { message: 'Process stopped' }.to_json
  rescue => e
    # 错误处理
    status 500
    { error: e.message }.to_json
  end

end

# 设置Sinatra为开发模式
set :environment, :development

# 设置端口号
set :port, 4567

# 启动Sinatra服务器
run!