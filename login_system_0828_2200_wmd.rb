# 代码生成时间: 2025-08-28 22:00:17
# 模拟数据库中的用户数据
USER_DATABASE = {
  "user1" => "password1",
  "user2" => "password2"
}

# 登录系统的主类
class LoginSystem < Sinatra::Base
  # 设置端口号
  set :port, 4567

  # 设置全局变量来存储当前登录的用户
  enable :sessions
  set :session_secret, 'my_secret_key'

  # 路由：展示登录页面
  get '/login' do
    erb :login
  end

  # 路由：处理登录请求
  post '/login' do
    # 获取表单中的用户名和密码
    username = params[:username]
    password = params[:password]
    # 验证用户名和密码
    if USER_DATABASE[username] && USER_DATABASE[username] == password
      # 设置会话中的用户名
      session[:username] = username
      "登录成功！欢迎回来，#{username}。"
    else
      # 登录失败，重定向到登录页面并显示错误信息
      "用户名或密码错误。"
    end
  end

  # 路由：登出操作
  get '/logout' do
    # 清除会话中的用户名
    session[:username] = nil
    "你已登出。"
  end

  # 路由：展示受保护的页面
  get '/dashboard' do
    # 检查用户是否已登录
    unless session[:username]
      redirect '/login'
      return
    end
    "欢迎来到仪表板，#{session[:username]}。"
  end

  # 路由：处理用户注册请求（这个例子中不实现注册功能，仅作展示）
  post '/register' do
    "注册功能尚未实现。"
  end
end

# 使用ERB模板引擎展示登录页面
__END__

@login
<!doctype html>
<html>
<head>
  <title>Login</title>
</head>
<body>
  <h2>Login</h2>
  <form action="/login" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required>
    <br>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    <br>
    <input type="submit" value="Login">
  </form>
</body>
</html>