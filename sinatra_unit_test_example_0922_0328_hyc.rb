# 代码生成时间: 2025-09-22 03:28:06
# 这是一个简单的 Sinatra 应用，用于演示单元测试框架的集成。
class MyApp < Sinatra::Base
  # 一个简单的路由，返回 Hello World
  get '/' do
    'Hello World!'
  end
end

# 使用 RSpec 和 Rack::Test 进行单元测试
RSpec.describe 'MyApp' do
  include Rack::Test::Methods

  def app
    MyApp
  end

  # 测试根路由
  it 'responds to the root route' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end
end