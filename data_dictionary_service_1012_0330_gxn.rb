# 代码生成时间: 2025-10-12 03:30:25
# 设置日志记录
LOGGER = Logger.new(STDOUT)
LOGGER.level = Logger::INFO

# 存储数据字典的内存结构
DATA_DICTIONARY = {}

# 路由：获取所有数据字典
get '/data-dictionaries' do
  content_type :json
  LOGGER.info("Fetching all data dictionaries")
  DATA_DICTIONARY.to_json
end

# 路由：根据id获取单个数据字典
get '/data-dictionaries/:id' do |id|
  content_type :json
  LOGGER.info("Fetching data dictionary with id: #{id}")
  data_dictionary = DATA_DICTIONARY[id]
  if data_dictionary
    data_dictionary.to_json
  else
    error(404, "Data dictionary not found")
  end
end

# 路由：创建一个新的数据字典
post '/data-dictionaries' do
  content_type :json
  LOGGER.info("Creating a new data dictionary")
  data = JSON.parse(request.body.read)
  # 错误处理：确保name和description字段存在
  unless data['name'] && data['description']
    error(400, 'Missing required parameters: name and description')
  end
  id = DATA_DICTIONARY.keys.max.to_i + 1
  DATA_DICTIONARY[id] = data
  { 'id' => id, 'data' => DATA_DICTIONARY[id] }.to_json
end

# 路由：更新现有的数据字典
put '/data-dictionaries/:id' do |id|
  content_type :json
  LOGGER.info("Updating data dictionary with id: #{id}")
  data = JSON.parse(request.body.read)
  data_dictionary = DATA_DICTIONARY[id]
  if data_dictionary
    DATA_DICTIONARY[id] = data
    { 'id' => id, 'data' => DATA_DICTIONARY[id] }.to_json
  else
    error(404, "Data dictionary not found")
  end
end

# 路由：删除数据字典
delete '/data-dictionaries/:id' do |id|
  LOGGER.info("Deleting data dictionary with id: #{id}")
  data_dictionary = DATA_DICTIONARY.delete(id)
  if data_dictionary
    { 'status' => 'success', 'message' => "Data dictionary with id #{id} deleted" }.to_json
  else
    error(404, "Data dictionary not found")
  end
end