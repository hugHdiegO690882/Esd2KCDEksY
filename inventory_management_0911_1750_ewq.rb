# 代码生成时间: 2025-09-11 17:50:55
# 库存管理系统
# Inventory Management System
class InventoryManagement < Sinatra::Base
  # 库存数据存储结构
  @@inventory = {}

  # GET请求，返回库存列表
  get '/inventory' do
    content_type :json
    { inventory: @@inventory }.to_json
  end

  # POST请求，添加新库存项
  post '/inventory' do
    content_type :json
    item = JSON.parse(request.body.read)
    if item['name'] && item['quantity'] && item['price']
      @@inventory[item['name']] = { quantity: item['quantity'], price: item['price'] }
      { message: 'Item added successfully' }.to_json
    else
      { error: 'Invalid item details' }.to_json
    end
  end

  # PUT请求，更新库存项
  put '/inventory/:name' do
    content_type :json
    name = params['name']
    item = JSON.parse(request.body.read)
    if @@inventory[name]
      @@inventory[name][:quantity] = item['quantity'] if item['quantity']
      @@inventory[name][:price] = item['price'] if item['price']
      { message: 'Item updated successfully' }.to_json
    else
      { error: 'Item not found' }.to_json
    end
  end

  # DELETE请求，删除库存项
  delete '/inventory/:name' do
    content_type :json
    name = params['name']
    if @@inventory[name]
      @@inventory.delete(name)
      { message: 'Item deleted successfully' }.to_json
    else
      { error: 'Item not found' }.to_json
    end
  end

end

# 运行Sinatra应用
run! if app_file == $0