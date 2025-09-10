# 代码生成时间: 2025-09-10 09:33:04
# 存储主题的键名
THEME_KEY = 'theme'

# 主题切换应用
class ThemeSwitcher < Sinatra::Application
  # 设置默认主题
  enable :session
  set :theme, 'default'

  # 首页，显示当前主题
  get '/' do
    "<h1>Welcome to the Theme Switcher!</h1>
<p>Your current theme is: #{session[:theme]}</p>"
  end

  # 主题切换路由
  post '/switch_theme' do
    # 获取新的theme参数
    new_theme = params['theme']
    # 验证主题是否有效
    unless %w[default dark light].include?(new_theme)
      status 400
      return "<h1>Invalid theme.</h1>"
    end
    # 更新session中的主题
    session[:theme] = new_theme
    # 重定向回首页
    redirect '/'
  end
end

# 运行应用
run! if app_file == $0