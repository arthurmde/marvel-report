class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.integer :comic_id
      t.string :title
      t.integer :issue
      t.text :description
      t.string :thumbnail

      t.timestamps
    end
  end
end
