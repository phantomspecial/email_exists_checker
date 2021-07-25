class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string        :to_address,      null: false
      t.string        :ses_message_id
      t.integer       :send_result
      t.timestamps
    end
  end
end
