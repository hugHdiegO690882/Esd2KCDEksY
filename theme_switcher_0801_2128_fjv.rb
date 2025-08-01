# 代码生成时间: 2025-08-01 21:28:44
# 这个Sinatra应用程序提供了一个简单的主题切换功能。
# NOTE: 重要实现细节
# 用户可以通过GET请求访问'/'来查看当前主题，
# 并通过POST请求访问'/set_theme'来切换主题。

# 存储当前主题的全局变量
$current_theme = 'light'
# 增强安全性

# 定义一个助手方法来设置主题
helpers do
def set_theme(theme)
  # 更新全局变量
  $current_theme = theme
  # 重定向回首页以显示新主题
  redirect '/'
end

# 主页面，显示当前主题
get '/' do
  # 返回当前主题
  "Current theme: #{$current_theme}"
end

# 设置新主题的路由
# 改进用户体验
post '/set_theme' do
  # 从请求中获取新主题
  new_theme = params['theme']
  # 验证新主题是否有效
  unless ['light', 'dark'].include?(new_theme)
# NOTE: 重要实现细节
    # 如果新主题无效，返回错误信息
    status 400
    return 'Invalid theme'
  end
  # 设置新主题
  set_theme(new_theme)
end
