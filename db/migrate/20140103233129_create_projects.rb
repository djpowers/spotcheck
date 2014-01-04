class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.string :status
      t.datetime :due_date

      t.timestamps
    end
  end
end
