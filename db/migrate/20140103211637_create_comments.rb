class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.string :timecode_start
      t.string :timecode_end
      t.integer :user_id, null: false
      t.integer :video_id, null: false

      t.timestamps
    end
  end
end
