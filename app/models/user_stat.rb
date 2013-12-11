class UserStat <  ActiveRecord::Base
  #attr_accessible :user_id, :lottery_free_draws, :quest_claims, :messages_unreads
  belongs_to :user
  @queue = 'stat'

  def self.perform(user_id)
    user = User.find(user_id)
    stat = UserStat.find_or_create_by_user_id user_id
    LotteryStat.reload(user) if user.lottery_stat.nil?
    stat.lottery_free_draws = user.reload.lottery_stat.free_draws
    stat.messages_unreads = user.unread_messages.count
    stat.quest_claims = QuestTemplate.new_quests_count(user)
    stat.save!
    stat
  end

  def self.sync(user, async=true)
    async = false if Rails.env.test?
    if async
      Resque.enqueue UserStat, user.id
    else
      UserStat.perform user.id
    end
  end
end