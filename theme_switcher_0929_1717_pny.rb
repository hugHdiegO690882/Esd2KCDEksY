# 代码生成时间: 2025-09-29 17:17:24
# ThemeSwitcher is a simple Sinatra application that allows users to switch between different themes.
class ThemeSwitcher < Sinatra::Application

  # Set the default theme to 'light'
  set :theme, 'light'

  # GET / - The home page where users can switch themes
  get '/' do
    # Render the theme switcher view
    erb :theme_switcher
  end

  # POST /switch_theme - Endpoint to switch the theme
  post '/switch_theme' do
    # Retrieve the new theme from the form submission
    new_theme = params[:theme]

    # Check if the new theme is valid
    if ['light', 'dark'].include?(new_theme)
      # Set the theme in the session
      session[:theme] = new_theme
      # Redirect back to the home page with a success message
      redirect '/' do
        "Theme switched to #{new_theme} successfully!"
      end
    else
      # If the theme is not valid, redirect back with an error message
      redirect '/' do
        "Error: Invalid theme selected. Please choose either 'light' or 'dark'."
# 增强安全性
      end
    end
  end

  # Helper method to get the current theme from the session
 helpers do
    def current_theme
      session[:theme] || settings.theme
    end
  end

end
# 添加错误处理

# Views/theme_switcher.erb
# <h1>Theme Switcher</h1>
# <form action="/switch_theme" method="post">
#   <label for="theme">Choose a theme:</label>
#   <select name="theme" id="theme">
#     <option value="light">Light</option>
# 增强安全性
#     <option value="dark">Dark</option>
#   </select>
# 添加错误处理
#   <button type="submit">Switch Theme</button>
# </form>
# <p>Your current theme is: <strong><%= current_theme %></strong></p>
