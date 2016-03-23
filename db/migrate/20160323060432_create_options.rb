class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :text
      t.integer :poll_id
    end
  end
end
