# 代码生成时间: 2025-10-09 21:28:41
# 考勤打卡系统
class AttendanceSystem < Sinatra::Base

  # 设置数据库文件
  set :database, {adapter: 'sqlite3', database: 'attendance.db'}

  # 数据库迁移
  configure :development do
    ActiveRecord::Migration.create_table(:attendances) do |t|
      t.datetime :check_in_time
      t.integer :user_id
    end
  end

  # 允许跨域请求
  configure do
    enable :cross_origin
  end

  # 获取所有考勤记录
  get '/attendances' do
    content_type :json
    Attendance.all.to_json
  end

  # 创建新的考勤记录
  post '/attendances' do
    content_type :json
    request.body.rewind
    params = JSON.parse request.body.read

    attendance = Attendance.new do |a|
      a.user_id = params['user_id']
      a.check_in_time = Time.now
    end

    if attendance.save
      { status: 'success', message: 'Attendance recorded successfully' }.to_json
    else
      { status: 'error', message: 'Failed to record attendance' }.to_json
    end
  end

  # 错误处理
  error do
    e = request.env['sinatra.error']
    error_response = { status: 'error', message: e.message }
    error_response.to_json
  end

end

# 考勤记录模型
class Attendance < ActiveRecord::Base
  # 关联用户ID
  belongs_to :user
end
