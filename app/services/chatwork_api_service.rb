require "chatwork"
class ChatworkApiService
	def initialize
		ChatWork.api_key = ENV["CW_API_KEY"]
		@room_id = ENV["CW_ROOM_ID"]
	end

	def send(message)
		ChatWork::Message.create(room_id: @room_id, body: message)
	end
end