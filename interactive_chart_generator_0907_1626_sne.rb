# 代码生成时间: 2025-09-07 16:26:44
# interactive_chart_generator.rb
# 使用Sinatra框架创建的交互式图表生成器

require 'sinatra'
require 'json'
require 'gruff' # 需要安装gruff gem

# 设置静态文件目录
set :public_folder, Proc.new { File.join(root, 'public') }

# 错误处理
error do
  e = request.env['sinatra.error']
  K.logger.error "Error: #{e.message}" if K.respond_to?(:logger)
  "Sorry, something went wrong."
end

# 首页路由，显示表单
get '/' do
  erb :index
end

# 接收用户输入并生成图表
post '/create_chart' do
  # 获取输入数据
  data = JSON.parse(request.body.read)
  
  # 错误处理，确保数据格式正确
  if data['labels'].nil? || data['values'].nil?
    halt 400, { 'Content-Type' => 'application/json' }, JSON.generate({ error: 'Missing labels or values' })
  end
  
  # 生成图表
  begin
    g = Gruff::Bar.new('800x600')
    g.title = 'Interactive Chart Generator'
    data['labels'].each_with_index do |label, index|
      g.data(label, data['values'][index])
    end
    g.write('public/chart.png')
  rescue => e
    halt 500, { 'Content-Type' => 'application/json' }, JSON.generate({ error: 