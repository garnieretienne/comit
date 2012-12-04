class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :name
      t.string :subdomain
      t.string :git
      t.string :path

      t.timestamps
    end
  end
end
