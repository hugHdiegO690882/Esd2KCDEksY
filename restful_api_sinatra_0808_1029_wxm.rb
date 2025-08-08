# 代码生成时间: 2025-08-08 10:29:54
# RESTful API using Ruby and Sinatra framework
require 'sinatra'
require 'json'

# A simple hash to simulate a database
@@todos = []

# Helper method to generate a unique id for each todo item
def generate_id
  @@todos.length + 1
end

# GET /todos - retrieves a list of all todo items
get '/todos' do
  content_type :json
  {todos: @@todos}.to_json
end

# GET /todos/:id - retrieves a single todo item by id
get '/todos/:id' do |id|
  content_type :json
  todo = @@todos.find { |t| t[:id] == id.to_i }
  if todo
    todo.to_json
  else
    {error: "Todo with id #{id} not found"}.to_json
  end
end

# POST /todos - creates a new todo item
post '/todos' do
  content_type :json
  todo = JSON.parse(request.body.read)
  if todo.has_key?('task') && !todo['task'].empty?
    @@todos.push({id: generate_id, task: todo['task']})
    {todo: @@todos.last}.to_json
  else
    {error: 'Task is required'}.to_json
  end
end

# PUT /todos/:id - updates an existing todo item
put '/todos/:id' do |id|
  content_type :json
  todo = @@todos.find { |t| t[:id] == id.to_i }
  if todo.nil?
    {error: "Todo with id #{id} not found"}.to_json
  else
    new_task = JSON.parse(request.body.read)
    todo[:task] = new_task['task'] if new_task.has_key?('task') && !new_task['task'].empty?
    {todo: todo}.to_json
  end
end

# DELETE /todos/:id - deletes a todo item
delete '/todos/:id' do |id|
  content_type :json
  index = @@todos.index { |t| t[:id] == id.to_i }
  if index
    {todo: @@todos.delete_at(index)}.to_json
  else
    {error: "Todo with id #{id} not found"}.to_json
  end
end
