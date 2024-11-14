require 'line/bot'

class Line::LineBotsController < ApplicationController
	def send_shift_message(user_id)
		message = {
			type: 'text',
			text: '明日シフトがあります！'
		}
		client.push_message(user_id, message)
	end

	def callback
		body = request.body.read
		signature = request.env['HTTP_X_LINE_SIGNATURE']
		unless client.validate_signature(body, signature)
			return head :bad_request
		end

		events = client.parse_events_from(body)
		message = {
			type: 'text',
			text: 'チャットしていただきありがとうございます！\nLINE Botはテキストのみの対応です😭\nご了承ください'
		}
		events.each do |event|
			case event
			when Line::Bot::Event::Message
				case event.type
				when Line::Bot::Event::MessageType::Text
					code = event.message['text']

					if code.to_s == "ヘルプ"
						message[:text] = "シフト通知をするLINE Botの設定方法を紹介します！\n\n1. アプリで整数4桁の認証コードを生成する\n2. 認証コードをコピーする\n3. LINE Botへ認証コードを送信する\n\n認証に成功すると次の午前9時からシフト通知を行います🚀"
					else
						# 既に登録済みの場合
						# User テーブルから検索
						if event['replyToken'].exist
							message[:text] = "既に登録されているようです👀\nいつもご利用いただきありがとうございます！"

						# 未登録の場合
						# 数値の場合
						elsif code.match?(/\A\d+\z/) && code.abs.to_s.size == 4
							# DBから調査
							message[:text] = "認証に成功しました🚀\nご利用いただきありがとうございます！"

						else
							# 整数４桁で入力するよう促す
							message[:text] = "チャットしていただきありがとうございます！\nLINE Botは個別にチャットすることはできません😭\n\n使い方の詳細は「ヘルプ」とお問合せください"
						end
					end
				end
			end
		end

		client.reply_message(event['replyToken'], message)
		head :ok
	end

	def register_auth_code
		if AuthCode.register_auth_code(input_params[:auth_code], input_params[:user_id])
			render json: { message: I18n.t('line_bot.register_auth_code.success') }, status: :ok
		else
			render json: { message: I18n.t('line_bot.register_auth_code.failed') }, status: :not_found
		end
	end

	private

	def input_params
		params.permit(:user_id, :auth_code)
	end

	def client
		@client ||= Line::Bot::Client.new { |config|
			config.channel_id = ENV["LINE_CHANNEL_ID"]
			config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
			config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
		}
	end
end