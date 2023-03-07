class ChatsController < ApplicationController
  before_action :reject_non_related,only:[:show]

  def show
    @user=User.find(params[:id])
    # どのユーザーとチャットをするのかを取得
    rooms=current_user.user_rooms.pluck(:room_id)
    # カレントユーザーのuser_roomにあるroom_idの値の配列をroomsに代入。
    user_rooms=UserRoom.find_by(user_id:@user.id,room_id:rooms)

    unless user_rooms.nil?
      # ユーザールームが無くなかった場合（つまりあった）
      @room=user_rooms.room
    else
      @room=Room.new
      @room.save
      UserRoom.create(user_id:current_user.id,room_id:@room.id)
      UserRoom.create(user_id:@user.id,room_id:@room.id)
      # user_roomをカレントユーザー分とチャット相手分を作る
    end
    @chats=@room.chats
    # チャットの一覧用の変数
    @chat=Chat.new(room_id:@room.id)
    # チャットの投稿用の変数
  end

  def create
    @chat=current_user.chats.new(chat_params)
    @chat.save
    redirect_to request.referer
  end


  private

  def chat_params
    params.require(:chat).permit(:message,:room_id)
  end

  def reject_non_related
    user=User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
