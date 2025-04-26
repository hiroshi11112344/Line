class Profile < ApplicationRecord
  belongs_to :user

  #before_create は、新しいレコードが create される前に実行されるコールバック
  before_create :generate_unique_id #ランダム８桁のID

  serialize :friend_requests, coder: JSON# 配列を保存

  serialize :friends, coder: JSON 

  validates :unique_id, uniqueness: true #ランダム８桁のID unique_id の値がデータベース内で一意 (ユニーク) であることを保証 

  validates :has_partner, inclusion: { in: [true, false] } # 🔹 true/false のみ許可　(恋人)

  private
  def generate_unique_id
    self.unique_id ||= SecureRandom.hex(4) # 8桁のランダムID生成
  end

  # 数字　桁数　数字の大きさ
  # 年
  validates :birth_year,presence: true,
    numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1000,
    ess_than_or_equal_to: Date.current.year
  }
  # 月
  validates :birth_month,presence: true,
  numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 12
  }
  # 日
  validates :birth_day,presence: true,
  numericality: {
  only_integer: true,
  greater_than_or_equal_to: 1,
  less_than_or_equal_to: 31
}
end
