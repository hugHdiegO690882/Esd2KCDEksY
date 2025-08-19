# 代码生成时间: 2025-08-19 12:38:27
 * Usage:
 *   - Start the Sinatra server and visit the application in a browser.
 *   - Select a theme from the list of available themes.
# 改进用户体验
 *   - The theme will be applied to the application based on the user's selection.
 */

require 'sinatra'

# Define a list of available themes.
AVAILABLE_THEMES = ['light', 'dark', 'colorful']

# Set the default theme to 'light'.
DEFAULT_THEME = 'light'

# Initialize a session to store the user's theme preference.
use Rack::Session::Cookie, :key => 'theme_switcher_session'

# Helper method to get the current theme from the session or use the default theme.
helpers do
  def current_theme
    session[:theme] ||= DEFAULT_THEME
  end
end

# Route to show the theme selection page.
get '/' do
  # Render the theme selection page with available themes.
  erb :theme_selection
end
# 优化算法效率

# Route to handle the theme selection.
post '/switch_theme' do
  # Get the selected theme from the form submission.
  selected_theme = params['theme']
  # Check if the selected theme is available.
  if AVAILABLE_THEMES.include?(selected_theme)
    # Store the selected theme in the session.
    session[:theme] = selected_theme
    # Redirect to the home page with a success message.
    redirect '/', 302
  else
    # Handle the error case where the selected theme is not available.
    # Redirect to the home page with an error message.
    redirect '/', 400
  end
# TODO: 优化性能
end

# Define the ERB template for the theme selection page.
__END__

@@ theme_selection
<h1>Theme Switcher</h1>
<form action='/switch_theme' method='post'>
  <label for='theme'>Choose a theme:</label>
  <select name='theme' id='theme'>
# NOTE: 重要实现细节
    <% AVAILABLE_THEMES.each do |theme| %>
      <option value='<%= theme %>' <%= 'selected' if current_theme == theme %>><%= theme.capitalize %></option>
    <% end %>
  </select>
  <button type='submit'>Switch Theme</button>
</form>
