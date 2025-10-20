class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mention, null: false
      t.references :mentioned, null: false

      t.timestamps
    end
    add_foreign_key :mentions, :reports, column: :mention_id
    add_foreign_key :mentions, :reports, column: :mentioned_id
    add_index :mentions, [:mention_id, :mentioned_id], unique: true
  end
end
