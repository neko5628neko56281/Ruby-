require 'csv'
require 'fileutils'

MEMO_DIRECTORY = "memos/"

def create_memo
  puts "メモのタイトルを入力してください："
  title = $stdin.gets.chomp
  filename = "#{title.downcase.gsub(' ', '_')}.csv"

  if File.exist?(MEMO_DIRECTORY + filename)
    puts "既に同じ名前のメモが存在します。別のタイトルを入力してください。"
    return
  end

  puts "メモしたい内容を記入してください　完了したらCtrl+Dを押します："
  content = read_multiline_input

  FileUtils.mkdir_p(MEMO_DIRECTORY)
  CSV.open(MEMO_DIRECTORY + filename, 'w') do |csv|
    csv << [content]
  end

  puts "メモが作成されました。"
end

def edit_memo
  puts "編集するメモのファイル名を入力してください："
  filename = "#{$stdin.gets.chomp.downcase.gsub(' ', '_')}.csv"

  if File.exist?(MEMO_DIRECTORY + filename)
    memos = CSV.read(MEMO_DIRECTORY + filename)

    puts "現在のメモの内容："
    puts memos[0][0]

    puts "メモしたい内容を記入してください　完了したらCtrl+Dを押します："
    content = read_multiline_input

    memos[0][0] += "\n" + content

    CSV.open(MEMO_DIRECTORY + filename, 'w') do |csv|
      csv << memos[0]
    end

    puts "メモが編集されました。"
  else
    puts "指定されたファイルが存在しません。"
  end
end

def read_multiline_input
  content = ""
  loop do
    line = $stdin.gets&.chomp
    break if line.nil?
    content += line + "\n"
  end
  content.chomp
end

def memo_app
  loop do
    puts "1. 新規でメモを作成"
    puts "2. 既存のメモ編集する"
    puts "3. 終了"
    puts "選択してください："

    choice = $stdin.gets.chomp.to_i

    case choice
    when 1
      create_memo
    when 2
      edit_memo
    when 3
      puts "アプリを終了します。"
      break
    else
      puts "無効な選択です。"
    end
  end
end

memo_app
