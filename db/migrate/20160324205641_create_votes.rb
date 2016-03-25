class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
    	t.references :option
    	t.string :session_id
    	t.integer :score
      t.timestamps null: false
    end
  end
end
