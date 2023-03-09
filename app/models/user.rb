class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  
  # グループのアソシエーション
  has_many :group_users
  has_many :groups,through: :group_users
  
  # ここからDMのアソシエーション
  has_many :user_rooms
  has_many :chats
  has_many :rooms,through: :user_rooms
  # ここまで
  
  # 閲覧数のアソシエーション
  has_many :view_counts,dependent: :destroy

# 自分がフォローしているユーザーとの関連　has_manyはforeign_key(外部キー)に結びついている→フォローはたくさんできるのでhas_many　外部キーに指定したところから検索するという意味
  has_many :active_relationships,class_name:"Relationship",foreign_key:"follower_id",dependent: :destroy
  # 下のコードで、フォローしているユーザーを配列の様に扱えるようになりました。
  has_many :following,through: :active_relationships,source: :followed
  # followedsという名前は英語として不適切です。代わりに、followingという名前を使いましょう。
  # sourceパラメーター → 「following配列の元はfollowed idの集合である」ということ

# 自分がフォローされるユーザーとの関連
  has_many :passive_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy
  has_many :followers,through: :passive_relationships,source: :follower
  # sourceキーは省略しても良い。Railsが “followers” を単数形にして自動的に外部キーfollower_idを探してくれるからです。
  # :sourceキーをそのまま残しているのは、has_many :followingとの類似性を強調させるためです。

#viewやcontrollerで使用する定義
  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id:other_user.id)
  end

  # ユーザーのフォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id:other_user.id).destroy
  end

  # フォローしていればtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction,length: {maximum:50}


  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path=Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io:File.open(file_path),filename:'default-image.jpg',content_type:'image/jpeg')
    end
    profile_image.variant(resize_to_limit:[width,height]).processed
  end
end
