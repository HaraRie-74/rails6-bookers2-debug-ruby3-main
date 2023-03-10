class RenameNameColumnToGroupMail < ActiveRecord::Migration[6.1]
  def change
    rename_column :group_mails, :name, :mail_title
  end
end
