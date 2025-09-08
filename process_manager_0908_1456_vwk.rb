# 代码生成时间: 2025-09-08 14:56:34
# 进程管理器
class ProcessManager < Sinatra::Base

  # 启动进程管理器
  get '/' do
    erb :index
  end

  # 获取所有进程信息
  get '/processes' do
    processes = `ps aux`.split("
")
    # 过滤掉第一行的标题信息
    processes.shift
    # 将进程信息转换为JSON格式
    content_type :json
    processes.to_json
  end

  # 启动一个新进程
  post '/start_process' do
    # 从请求体中获取进程名称和命令参数
    params = JSON.parse(request.body.read)
    command = params['command']
    # 检查命令参数是否有效
    halt 400, { error: 'Invalid command' }.to_json unless command
    # 启动进程
    `#{command} &`
    status 201
    { message: 'Process started successfully' }.to_json
  end

  # 停止一个进程
  post '/stop_process' do
    # 从请求体中获取进程ID
    params = JSON.parse(request.body.read)
    pid = params['pid']
    # 检查进程ID是否有效
    halt 400, { error: 'Invalid process ID' }.to_json unless pid
    # 停止进程
    `kill #{pid}`
    status 200
    { message: 'Process stopped successfully' }.to_json
  end

  # 错误处理
  error do
    'An error occurred'
  end

  # 设置模板文件夹
  set :views, File.dirname(__FILE__) + '/views'
end

# 运行进程管理器
run! if __FILE__ == $0
