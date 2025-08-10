# 代码生成时间: 2025-08-11 04:47:53
# 定义用户数据结构，用于验证
USERS = {
  "user1" => {
    "password_hash" => Digest::SHA256.hexdigest("password1"),
    "email" => "user1@example.com"
  },
  "user2" => {
    "password_hash" => Digest::SHA256.hexdigest("password2"),
    "email" => "user2@example.com"
  }
}

# 登录页面
get '/login' do
  erb :login
end

# 登录验证
post '/login' do
  username = params[:username]
  password = params[:password]

  # 检查用户名是否存在
  if user = USERS[username]
    # 验证密码
    if user[:password_hash] == Digest::SHA256.hexdigest(password)
      "Login successful"
    else
      status 401
      { error: 'Invalid credentials' }.to_json
    end
  else
    status 404
    { error: 'User not found' }.to_json
  end
end

# 登录页面的ERB模板（login.erb）
__END__
@@ login
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
</head>
<body>
  <h2>Login</h2>
  <form action="/login" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required>
    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>
    <button type="submit">Submit</button>
  </form>
</body>
</html>