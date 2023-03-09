class AddIndexGroupsName < ActiveRecord::Migration[6.1]
  def change
    add_index :groups, :name, unique: true
  end
end
