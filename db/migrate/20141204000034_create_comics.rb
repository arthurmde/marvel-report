class CreateComics < ActiveRecord::Migration
  def change
    create_table :comics do |t|
      t.integer :comic_id
      t.string :title
      t.integer :issue
      t.text :description
      t.string :thumbnail
      t.string :isbn
      t.integer :pages
      t.string :detail_url
      t.float :price
      t.date :sale_date
      t.timestamps
    end
  end
end
