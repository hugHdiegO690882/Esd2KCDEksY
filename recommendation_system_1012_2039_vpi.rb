# 代码生成时间: 2025-10-12 20:39:02
# 推荐系统的简单示例，使用Sinatra框架
# 推荐算法基于简单的协同过滤
class RecommendationSystem
  attr_accessor :users, :ratings, :similarity_threshold, :recommendation_count

  def initialize
    @users = {}
    @ratings = {}
    @similarity_threshold = 0.5
    @recommendation_count = 5
  end

  # 添加用户
  def add_user(user_id)
    @users[user_id] = []
  end

  # 用户评分
  def rate(user_id, item_id, rating)
    user_ratings = @ratings[user_id] ||= {}
    user_ratings[item_id] = rating
  end

  # 计算两个用户之间的相似度
  def similarity(user1, user2)
    return 0 unless @ratings[user1] && @ratings[user2]
    sum = 0
    count = 0
    @ratings[user1].each do |item, rating1|
      rating2 = @ratings[user2][item]
      sum += rating1 * rating2 if rating2
      count += 1 if rating2
    end
    sum / (count * 2.0)
  end

  # 推荐物品给用户
  def recommend(user_id)
    return [] unless @ratings[user_id]
    recommendations = []
    @users.each do |other_user, _|
      next if other_user == user_id
      similarity_score = similarity(user_id, other_user)
      next if similarity_score < @similarity_threshold
      @ratings[other_user].each do |item, _|
        next if @ratings[user_id][item]
        recommendations << item
      end
      break if recommendations.size >= @recommendation_count
    end
    recommendations
  end
end

# Sinatra应用
get '/recommendations/:user_id' do
  rs = RecommendationSystem.new
  # 添加用户和评分（示例数据）
  rs.add_user('user1')
  rs.add_user('user2')
  rs.rate('user1', 'item1', 5)
  rs.rate('user1', 'item2', 3)
  rs.rate('user2', 'item1', 4)
  rs.rate('user2', 'item3', 5)
  # 生成推荐
  recommendations = rs.recommend(params['user_id'])
  # 返回推荐结果
  { recommendations: recommendations }.to_json
end