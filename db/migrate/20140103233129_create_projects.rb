class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :status
      t.date :due_date
      t.time :due_time

      t.timestamps
    end
  end
end
