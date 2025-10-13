# 代码生成时间: 2025-10-13 18:24:33
# 这个类代表了A/B测试平台的一个会话
class AbTestSession
  attr_accessor :user_id, :group
  # 初始化方法
  def initialize(user_id)
    @user_id = user_id
    @group = group_assignment
  end

  # 根据用户ID分配组别，这里使用简单的模运算作为示例
  def group_assignment
    (user_id % 2).zero? ? 'Group A' : 'Group B'
  end
end

# 设置一个全局的变量来存储会话信息
$sessions = {}

# Sinatra的应用
class AbTestApp < Sinatra::Application
  # GET请求根路径，展示A/B测试的页面
  get '/' do
    erb :index
  end

  # POST请求，用于接收用户ID并创建A/B测试会话
  post '/start_session' do
    user_id = params['user_id']
    if user_id
      session = AbTestSession.new(user_id)
      $sessions[user_id] = session
      'Session started. User ID: %{user_id} is in %{group}' % { user_id: user_id, group: session.group }
    else
      'User ID is required.'
    end
  end

  # 错误处理
  not_found do
    'This page could not be found.'
  end

  error do
    'An error occurred.'
  end
end

# 设置Sinatra的模板视图文件夹
set :views, File.dirname(__FILE__) + '/views'