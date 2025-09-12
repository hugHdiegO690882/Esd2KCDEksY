# 代码生成时间: 2025-09-13 06:44:08
# Define the routes for the sorting service
get '/sort' do
  # Retrieve the sorting algorithm and array of numbers from the query parameters
  algorithm = params['algorithm']
  numbers = params['numbers']

  # Convert the string of numbers to an array of integers
  numbers_array = numbers.split(',').map(&:to_i)

  # Check if the algorithm is valid and the numbers array is not empty
  if !SUPPORTED_ALGORITHMS.include?(algorithm) || numbers_array.empty?
    # Return an error response if the algorithm is not supported or the array is empty
    error_response('Invalid algorithm or empty array', 400)
  else
    # Sort the numbers array using the selected algorithm
    sorted_numbers = case algorithm
                    when 'bubble'
                      bubble_sort(numbers_array)
                    when 'quick'
                      quick_sort(numbers_array)
                    when 'merge'
                      merge_sort(numbers_array)
                    else
                      # Default to bubble sort if an unknown algorithm is provided
                      bubble_sort(numbers_array)
                    end

    # Return the sorted array as a JSON response
    json_response(sorted_numbers)
  end
end

# Bubble Sort Algorithm
def bubble_sort(arr)
  arr.size.times do
    (arr.size - 1).times do |i|
      if arr[i] > arr[i + 1]
        arr[i], arr[i + 1] = arr[i + 1], arr[i]
      end
    end
  end
  arr
end

# Quick Sort Algorithm
def quick_sort(arr)
  return arr if arr.size <= 1
  pivot = arr.first
  left = arr[1..-1].select { |e| e <= pivot }
  right = arr[1..-1].select { |e| e > pivot }
  [quick_sort(left), [pivot], quick_sort(right)].flatten
end

# Merge Sort Algorithm
def merge_sort(arr)
  return arr if arr.size <= 1
  mid = arr.size / 2
  left = merge_sort(arr[0..mid-1])
  right = merge_sort(arr[mid..arr.size])
  merge(left, right)
end

def merge(left, right)
  result = []
  while left.any? && right.any?
    if left.first <= right.first
      result << left.shift
    else
      result << right.shift
    end
  end
  result.concat(left).concat(right)
end

# Helper method to return a JSON response
def json_response(data)
  content_type :json
  JSON.generate(data)
end

# Helper method to return an error response
def error_response(message, status)
  content_type :json
  JSON.generate(error: message).to_json
  halt(status)
end

# List of supported sorting algorithms
SUPPORTED_ALGORITHMS = ['bubble', 'quick', 'merge']
