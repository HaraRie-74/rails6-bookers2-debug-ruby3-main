class RelationshipsController < ApplicationController
  
  # フォローする Userモデルで定義したfollowメソッド
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  
  # フォローを外す Userモデルで定義したunfollowメソッド
  def destroy
    currnet_user.unfollow(params[:user_id])
    redirect_to request.refe
  end
  
  
end
