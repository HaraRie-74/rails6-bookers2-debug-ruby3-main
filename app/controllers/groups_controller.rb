class GroupsController < ApplicationController
before_action :authenticate_user!
before_action :ensure_correct_user,only:[:edit, :update, :destroy]

  def new
    @group=Group.new
  end

  def create
    @group=Group.new(group_params)
    @group.owner_id=current_user.id
    @group.users << current_user
    # グループ作成者をメンバーに追加
    if @group.save
      redirect_to groups_path
    else
      render "new"
    end
  end

  def join
    @group=Group.find(params[:group_id])
    @group.users << current_user
    # @group.usersに、current_userを追加しているということなんですね
    #「<<」は連結とかという意味。@group.usersで@groupに紐づいたuserを呼び出している→ 呼び出すuserにcurrent_userを追加しているという意味？
    redirect_to groups_path
  end

  def notjoin
    @group=Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def edit
    @group=Group.find(params[:id])
  end

  def update
    @group=Group.find(params[:id])
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end

  def destroy
    group=Group.find(params[:id])
    group.destroy
    redirect_to groups_path
  end

  def index
    @book=Book.new
    @book_new = Book.new
    @groups=Group.all
  end

  def show
    @book=Book.new
    @book_new=Book.new
    @group=Group.find(params[:id])
  end

  def mail_new
    @group=Group.find(params[:group_id])
    @mail=GroupMail.new
  end

  def mail_send
    @group=Group.find(params[:group_id])
    # from_user=User.find(@group.owner_id) ★本当はこれ
    # to_users=@group.users ★本当はこれ
    @mail=GroupMail.new(group_mail_params)
    if @mail.save
      # GroupmailMailer.send_mail(from_user,to_users,@mail).deliver ★本当はこれ
      GroupmailMailer.send_mail(@mail).deliver
      # 「メーラー名.メソッド名」として、クラスメソッドを呼び出す（GroupmailMailerのsend_mailの定義が呼び出される）
      # 実際の送信を担うのはdeliverメソッドです メーラーを起動して返ってきたメールのデータを送信します
    else
      render "mail_new"
    end
  end


  private

  def group_params
    params.require(:group).permit(:name,:introduction,:image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

  def group_mail_params
    params.require(:group_mail).permit(:mail_title,:mail_content)
  end

end
