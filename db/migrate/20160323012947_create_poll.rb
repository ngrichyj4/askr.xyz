class CreatePoll < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :slug
      t.string :question
      t.string :voting_style
    end
  end
end
