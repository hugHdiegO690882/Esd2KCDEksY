# 代码生成时间: 2025-08-05 09:31:31
# 引入Sinatra框架
require 'sinatra'

# 使用Sass来处理CSS
require 'sass'

# 设置Sinatra的静态文件目录
set :public_folder, 'public'

# 设置视图文件目录
set :views, 'views'

# 定义一个简单的路由，用于展示响应式布局
get '/' do
  # 渲染一个名为'index'的ERB模板
  erb :index
end

# 错误处理，当发生404错误时
error Sinatra::NotFound do
  erb :'404', locals: { message: 'Page not found' }
end

# 响应式布局的CSS文件
get '/css/responsive.css' do
  # 使用Sass渲染一个名为'responsive.scss'的SCSS文件
  content_type 'text/css', charset: 'utf-8'
  Sass::Engine.for_file('assets/stylesheets/responsive.scss', syntax: :scss).render
end

# 视图文件目录下的ERB模板(index.erb)
__END__

@@ index.erb
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Responsive Layout</title>
  <link rel="stylesheet" href="/css/responsive.css">
</head>
<body>
  <header>
    <h1>Responsive Layout Example</h1>
  </header>
  <main>
    <section>
      <p>This is a responsive layout example. Resize your browser to see how it adapts.</p>
    </section>
  </main>
  <footer>
    <p>&copy; 2023 Responsive Layout</p>
  </footer>
</body>
</html>

@@ 404.erb
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Page Not Found</title>
</head>
<body>
  <h1>404 Not Found</h1>
  <p><%= message %></p>
  <a href="/">Go Home</a>
</body>
</html>

# 这里是SCSS文件目录下的SCSS文件(responsive.scss)
assets/stylesheets/responsive.scss
$breakpoints: (
  'small': 576px,
  'medium': 768px,
  'large': 992px,
  'extra-large': 1200px
) !default;

@mixin responsive($breakpoint) {
  @if map-has-key($breakpoints, $breakpoint) {
    $value: map-get($breakpoint, $breakpoint);
    @media (min-width: $value) {
      @content;
    }
  }
}

body {
  margin: 0;
  padding: 0;
  font-family: Arial, sans-serif;
}

header, footer {
  background-color: #333;
  color: white;
  text-align: center;
  padding: 1rem 0;
}

main {
  padding: 1rem;
}

section {
  margin-bottom: 1rem;
}

@include responsive('small') {
  body {
    background-color: lightblue;
  }
}

@include responsive('medium') {
  body {
    background-color: lightgreen;
  }
}

@include responsive('large') {
  body {
    background-color: lightcoral;
  }
}

@include responsive('extra-large') {
  body {
    background-color: lightgrey;
  }
}
