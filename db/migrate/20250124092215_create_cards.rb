class CreateCards < ActiveRecord::Migration[7.2]
  def change
    create_table :cards do |t|
      t.string :title, null: false
      t.text :message, null: false
      t.binary :photo
      t.integer :coments_counter
      t.integer :likes_counter
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
