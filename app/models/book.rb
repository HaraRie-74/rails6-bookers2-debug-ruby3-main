class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :favorited_users,through: :favorites,source: :user
  # ↑過去一週間でいいねの多い順に投稿を表示するアソシエーション
  #  多対多で中間テーブルの先のモデルとアソシエーションする
  has_many :book_comments,dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id:user.id)
  end

end
