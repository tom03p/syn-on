class CreateCardsMusics < ActiveRecord::Migration[7.2]
  def change
    create_table :cards_musics do |t|
      t.references :card
      t.references :music

      t.timestamps
    end
  end
end
