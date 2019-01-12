require 'bundler'
Bundler.require
require 'fileutils'

Dotenv.load

TARGETCHANNEL = "cat_photo_system"

CAT_PHOTO_DIR = ENV["PHOTO_DIR_PASS"]

def post_photo(botobj, targetch, imagepath, caption)
    botobj.send_file(targetch, File.open(imagepath, 'r'), caption: caption)
end

# Discord botを初期化
bot = Discordrb::Bot.new (
    {
        :token => ENV["DISCORD_TOKEN"],
        :client_id => ENV["DISCORD_CLIENT_ID"]
    }
)

bot.run :async

# チャンネル情報を取得
ch_id = bot.find_channel(TARGETCHANNEL).first.id

if ch_id != nil then
    photos = Dir.glob("#{CAT_PHOTO_DIR}/*.jpg")

    photos.each do |additem|
        post_photo(bot, ch_id, additem, File.basename(additem))

        sleep 3
    end

    # 画像を削除
    FileUtils.rm_f(photos, :secure => true)
end

bot.stop

