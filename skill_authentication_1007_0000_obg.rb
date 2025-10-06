# 代码生成时间: 2025-10-07 00:00:29
# 技能认证平台
#
# 这个Sinatra应用提供了基本的CRUD功能来管理技能认证。

class SkillAuthentication < Sinatra::Base

  # 设置数据库文件
  enable :sessions
  set :session_secret, 'your_secret_key'

  # 数据库操作
  before do
    @db = 'skills.db'
  end

  # 首页，列出所有技能
  get '/' do
    @skills = JSON.parse(File.read(@db))
    erb :index
  end

  # 添加技能表单页面
  get '/new' do
    erb :new
  end

  # 添加技能的处理
  post '/skills' do
    skill = JSON.parse(request.body.read)
    @skills = JSON.parse(File.read(@db))
    @skills[skill['name']] = skill
    File.open(@db, 'w') { |f| f.write(@skills.to_json) }
    redirect '/'
  end

  # 编辑技能页面
  get '/skills/:name/edit' do
    skill_name = params['name']
    @skill = JSON.parse(File.read(@db))[skill_name]
    erb :edit
  end

  # 更新技能的处理
  patch '/skills/:name' do
    skill_name = params['name']
    new_skill_data = JSON.parse(request.body.read)
    @skills = JSON.parse(File.read(@db))
    @skills[skill_name] = new_skill_data
    File.open(@db, 'w') { |f| f.write(@skills.to_json) }
    redirect '/'
  end

  # 删除技能的处理
  delete '/skills/:name' do
    skill_name = params['name']
    @skills = JSON.parse(File.read(@db))
    @skills.delete(skill_name)
    File.open(@db, 'w') { |f| f.write(@skills.to_json) }
    redirect '/'
  end

  # 错误处理
  not_found do
    erb :'404'
  end

  # 内部服务器错误处理
  error do
    'An error occurred'
  end

end

# Helper methods can be added here
# In this example, we have a simple helper method for error messages
helpers do
  def error_message(message)
    "<p style='color: red;'>Error: #{message}</p>"
  end
end

# Views folder should contain 'index.erb', 'new.erb', 'edit.erb', and '404.erb' files.
# These files should be created separately and follow the Sinatra template conventions.
