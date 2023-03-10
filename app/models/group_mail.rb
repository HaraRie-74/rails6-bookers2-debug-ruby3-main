class GroupMail < ApplicationRecord
  belongs_to :group,optional: true
  # optional: true・・・外部キーがnillであることを許可してくれるオプション
  # groupmailはgroupの配下にあるので、本来ならばgroup_idカラムを持つ必要がある。(外部キーを持つ必要がある)
  # しかし、今回は設定していない。optional: trueをすることで、外部キーを持たなくてOKとなる設定。
  validates :mail_title,presence:true
  validates :mail_content,presence:true,length:{maximum:200}
end
