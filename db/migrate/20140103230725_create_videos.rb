class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.integer :revision_number, null: false
      t.boolean :approved, null: false, default: false
      t.integer :project_id, null: false

      t.timestamps
    end
  end
end
