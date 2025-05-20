# frozen_string_literal: true

print '開発環境のデータをすべて削除して初期データを投入します。よろしいですか？[Y/n]: ' # rubocop:disable Rails/Output
unless $stdin.gets.chomp.casecmp('Y').zero?
  puts '中止しました。' # rubocop:disable Rails/Output
  return
end

def picture_file(name)
  File.open(Rails.root.join("db/seeds/#{name}"))
end

Book.destroy_all

Book.create!(
  title: 'Ruby超入門',
  memo: 'Rubyの文法の基本をやさしくていねいに解説しています。',
  author: '五十嵐 邦明',
  picture: picture_file('cho-nyumon.jpg')
)

Book.create!(
  title: 'チェリー本',
  memo: 'プログラミング経験者のためのRuby入門書です。',
  author: '伊藤 淳一',
  picture: picture_file('cherry-book.jpg')
)

Book.create!(
  title: '楽々ERDレッスン',
  memo: '実在する帳票から本当に使えるテーブル設計を導く画期的な本！',
  author: '羽生 章洋',
  picture: picture_file('erd.jpg')
)

Book.create!(
  title: '#4',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#5',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#6',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#7',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#8',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#9',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#10',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#11',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#12',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#13',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#14',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#15',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#16',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#17',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#18',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#19',
  memo: '',
  author: '',
  picture: nil
)

Book.create!(
  title: '#20',
  memo: '',
  author: '',
  picture: nil
)

puts '初期データの投入が完了しました。' # rubocop:disable Rails/Output
