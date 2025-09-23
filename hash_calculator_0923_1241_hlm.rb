# 代码生成时间: 2025-09-23 12:41:30
# 哈希值计算工具，使用Sinatra框架搭建
class HashCalculator < Sinatra::Base
  # GET请求处理，展示表单界面
  get '/' do
    erb :index
  end

  # POST请求处理，接收用户输入并计算哈希值
  post '/calculate' do
    # 获取用户输入的数据
    input_data = params['data']
    # 检查输入是否为空
    if input_data.nil? || input_data.empty?
      return erb :error, locals: { message: '请输入要计算的数据' }
    end

    # 选择哈希算法（默认为SHA256）
    hash_algorithm = params['algorithm'] || 'SHA256'
    # 计算哈希值
    hash_value = Digest.const_get(hash_algorithm).hexdigest(input_data)
    # 返回结果页面
    erb :result, locals: { input_data: input_data, hash_value: hash_value, hash_algorithm: hash_algorithm }
  end

  # 错误处理页面
  error do
    erb :error, locals: { message: env['sinatra.error'].message }
  end
end

# 视图文件
__END__

@@index
<!DOCTYPE html>
<html>
<head>
  <title>哈希值计算工具</title>
</head>
<body>
  <h1>哈希值计算工具</h1>
  <form action="/calculate" method="post">
    <label for="data">输入数据:</label>
    <input type="text" id="data" name="data" required>
    <label for="algorithm">哈希算法:</label>
    <select id="algorithm" name="algorithm">
      <option value="SHA256">SHA256</option>
      <option value="SHA512">SHA512</option>
      <option value="MD5">MD5</option>
    </select>
    <button type="submit">计算哈希值</button>
  </form>
</body>
</html>

@@result
<!DOCTYPE html>
<html>
<head>
  <title>哈希值计算结果</title>
</head>
<body>
  <h1>哈希值计算结果</h1>
  <p>输入数据: <%= @input_data %></p>
  <p>哈希算法: <%= @hash_algorithm %></p>
  <p>哈希值: <%= @hash_value %></p>
  <a href="/">返回</a>
</body>
</html>

@@error
<!DOCTYPE html>
<html>
<head>
  <title>错误</title>
</head>
<body>
  <h1>错误</h1>
  <p><%= @message %></p>
  <a href="/">返回</a>
</body>
</html>