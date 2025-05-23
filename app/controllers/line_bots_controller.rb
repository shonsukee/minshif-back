require 'line/bot'

class LineBotsController < ApplicationController
	def send_shift_message(line_user_id, text_lines)
		message = {
			type: 'text',
			text: text_lines
		}
		client.push_message(line_user_id, message)
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
			text: I18n.t('line_bot.callback.not_text')
		}
		events.each do |event|
			case event
			when Line::Bot::Event::Message
				case event.type
				when Line::Bot::Event::MessageType::Text
					code = event.message['text']
					line_user_id = event['source']['userId']

					if code.to_s == "ヘルプ"
						message[:text] = I18n.t('line_bot.callback.help')
					else
						user = User.find_by(line_user_id: line_user_id)

						# 既に登録済みの場合
						if user
							message[:text] = I18n.t('line_bot.callback.already_registered')

						# 未登録の場合
						elsif code.match?(/\A\d+\z/) && code.to_i.abs.to_s.size == 4
							# 有効期限は30分
							auth_code_record = AuthCode.where(auth_code: code)
														.where('created_at > ?', 30.minutes.ago)
														.first

							if auth_code_record&.auth_code_matches?(code) && User.register_line_id(auth_code_record.user_id, line_user_id)
								message[:text] = I18n.t('line_bot.callback.success')
							else
								message[:text] = I18n.t('line_bot.callback.failed')
							end
						else
							# 整数４桁で入力するよう促す
							message[:text] = I18n.t('line_bot.callback.invalid_code')
						end
					end
				end
			end
		end

		client.reply_message(events[0]['replyToken'], message)
		head :ok
	end

	def create
		if AuthCode.create(input_register_params[:auth_code], input_register_params[:user_id])
			render json: { message: I18n.t('line_bot.create.success') }, status: :ok
		else
			render json: { error: I18n.t('line_bot.create.failed') }, status: :bad_request
		end
	end

	def index
		auth_code = AuthCode.index(input_fetch_params[:user_id])
		render json: auth_code
	end

	private

	def input_register_params
		params.permit(:user_id, :auth_code)
	end

	def input_fetch_params
		params.permit(:user_id)
	end

	def client
		@client ||= Line::Bot::Client.new { |config|
			config.channel_id = ENV["LINE_CHANNEL_ID"]
			config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
			config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
		}
	end
end
