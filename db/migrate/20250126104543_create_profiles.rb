class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :nickname, null:false, default:'名無しの権兵衛'
      t.text :message
      t.date :birthday
      t.binary :photo
      t.text :comments_to_music
      t.text :favorite_game
      t.text :favorite_video
      t.text :favorite_comic
      t.references :user, foreign_key:true

      t.timestamps
    end
  end
end
