# 代码生成时间: 2025-10-10 02:32:19
# CareerPlanningApp is a Sinatra application for career planning system
class CareerPlanningApp < Sinatra::Base

  # Index route to show the career planning form
  get '/' do
    erb :form
  end

  # POST route to process career planning form data
  post '/plan' do
    # Extract data from params
    career_goal = params['career_goal']
    skills_needed = params['skills_needed']
    years_to_completion = params['years_to_completion']

    # Basic error handling
    if career_goal.nil? || career_goal.empty? || skills_needed.nil? || skills_needed.empty? || years_to_completion.nil? || years_to_completion.empty?
      "Missing data. Please fill out all fields."
    else
      "Career planning details:<br>
      Goal: #{career_goal}<br>
      Skills Needed: #{skills_needed}<br>
      Timeframe: #{years_to_completion} years"
    end
  end

  # Custom error route for 404 errors
  not_found do
    erb :'404', :locals => { :status => 404 }
  end

  # Run the application on port 4567
  run! if app_file == $0
end

# Templates folder should contain 'form.erb' for the career planning form
# And '404.erb' for the custom 404 error page
