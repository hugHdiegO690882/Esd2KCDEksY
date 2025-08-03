# 代码生成时间: 2025-08-03 23:15:22
# 批量文件重命名工具
# BatchRenamer 是一个 Sinatra 应用，用于批量重命名给定目录下的文件。
class BatchRenamer < Sinatra::Base

  # GET /renames 显示批量重命名表单
  get '/renames' do
    erb :renames
  end

  # POST /renames 处理批量重命名请求
  post '/renames' do
    # 获取表单参数
    dir = params['dir']
    pattern = params['pattern']
    replace_with = params['replace_with']

    # 错误处理，检查参数是否为空
    unless dir && pattern && replace_with
      return erb :renames, locals: { error: '所有字段都是必填的' }
    end

    # 检查目录是否存在
    unless Dir.exist?(dir)
      return erb :renames, locals: { error: '目录不存在' }
    end

    # 重命名文件
    files = Dir.glob(File.join(dir, "*#{pattern}*"))
    renamed_files = 0
    files.each do |file|
      new_name = file.gsub(pattern, replace_with)
      FileUtils.mv(file, new_name)
      renamed_files += 1
    rescue StandardError => e
      # 错误处理，记录重命名失败的文件和错误信息
      puts 