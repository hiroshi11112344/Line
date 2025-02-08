class Profile < ApplicationRecord
  belongs_to :user
  #before_create は、新しいレコードが create される前に実行されるコールバック
  before_create :generate_unique_id #ランダム８桁のID

  serialize :friend_requests, Array # 配列を保存

  serialize :friends, Array # 配列を保存

  validates :unique_id, uniqueness: true #ランダム８桁のID unique_id の値がデータベース内で一意 (ユニーク) であることを保証 

  validates :has_partner, inclusion: { in: [true, false] } # 🔹 true/false のみ許可　(恋人)

  private

  def generate_unique_id
    self.unique_id ||= SecureRandom.hex(4) # 8桁のランダムID生成
  end
end
