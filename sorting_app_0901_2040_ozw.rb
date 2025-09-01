# 代码生成时间: 2025-09-01 20:40:45
# SortingApp class handles the logic for sorting algorithms
class SortingApp
# 优化算法效率
  # Bubble sort algorithm implementation
  def bubble_sort(array)
    array.dup.sort_by!(&:nth)
  end

  # Selection sort algorithm implementation
  def selection_sort(array)
    sorted_array = []
    until array.empty?
      sorted_array << array.delete(array.min)
    end
    sorted_array
  end

  # Insertion sort algorithm implementation
  def insertion_sort(array)
    array.each_cons(2).map(&:first)
  end
# 改进用户体验
end

# Sinatra setup and route handling
get '/bubble_sort' do
  content_type :json
  array = params['array']
  if array.is_a?(Array) && array.all?(Numeric)
    SortingApp.new.bubble_sort(array).to_json
  else
    { error: 'Invalid input: please provide an array of numbers.' }.to_json
  end
# 增强安全性
end

get '/selection_sort' do
  content_type :json
  array = params['array']
# 添加错误处理
  if array.is_a?(Array) && array.all?(Numeric)
# 优化算法效率
    SortingApp.new.selection_sort(array).to_json
# 添加错误处理
  else
    { error: 'Invalid input: please provide an array of numbers.' }.to_json
  end
end

get '/insertion_sort' do
  content_type :json
# 改进用户体验
  array = params['array']
  if array.is_a?(Array) && array.all?(Numeric)
    SortingApp.new.insertion_sort(array).to_json
  else
    { error: 'Invalid input: please provide an array of numbers.' }.to_json
  end
end