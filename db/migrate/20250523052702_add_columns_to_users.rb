class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :username, null: false, comment: 'ユーザー名'
      t.string :postcode, null: false, comment: '郵便番号'
      t.string :address, null: false, comment: '住所'
      t.string :biography, null: false, comment: '自己紹介'
    end
  end
end
