class CreateMusics < ActiveRecord::Migration[7.2]
  def change
    create_table :musics do |t|
      t.string :link, null: false

      t.timestamps
    end
  end
end
