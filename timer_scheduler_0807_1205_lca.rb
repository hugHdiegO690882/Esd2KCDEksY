# 代码生成时间: 2025-08-07 12:05:21
# TimerSchedulerApp is a Sinatra application that provides a simple timer task scheduler.
class TimerSchedulerApp < Sinatra::Base

  # Initialize the scheduler
  before do
    @scheduler = Rufus::Scheduler.new
  end

  # Endpoint to schedule a new task
  post '/schedule' do
    # Parse the JSON payload
    task_info = JSON.parse(request.body.read)
    # Extract task details
    task_name = task_info['name']
    task_interval = task_info['interval']
    task_command = task_info['command']

    # Error handling
    halt 400, {'error' => 'Missing task details'}.to_json unless task_name && task_interval && task_command
    halt 400, {'error' => 'Invalid interval'}.to_json unless task_interval.match?(/\d+/)

    # Schedule the task
    begin
      @scheduler.every(task_interval.to_i, :first_in => 0) do
        # Execute the command (in this example, we just log it)
        puts "Executing task: #{task_name}"
        puts "Command: #{task_command}"
      end
      status 200
      {'message' => 'Task scheduled successfully'}.to_json
    rescue Rufus::Scheduler::InvalidIntervalError => e
      halt 400, {'error' => e.message}.to_json
    end
  end

  # Endpoint to cancel a scheduled task
  post '/cancel/:task_name' do
    task_name = params[:task_name]
    task = @scheduler.jobs.find { |job| job.tags.include?(task_name) }
    if task
      task.unschedule
      status 200
      {'message' => 