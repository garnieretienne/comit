class AddTokenToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :token, :string
  end
end
