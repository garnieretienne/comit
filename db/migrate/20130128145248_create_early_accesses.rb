class CreateEarlyAccesses < ActiveRecord::Migration
  def change
    create_table :early_accesses do |t|
      t.string :email_address

      t.timestamps
    end
  end
end
