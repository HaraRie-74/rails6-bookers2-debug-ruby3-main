class RenameContentColumnToGroupMail < ActiveRecord::Migration[6.1]
  def change
    rename_column :group_mails, :content, :mail_content
  end
end
