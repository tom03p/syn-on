class AddUniquenameToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :uniquename, :string
    add_index :users, :uniquename, unique: true
  end
end
