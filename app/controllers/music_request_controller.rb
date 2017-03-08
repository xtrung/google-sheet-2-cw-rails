require 'will_paginate/array'

class MusicRequestController < ApplicationController
	def index
		@music_data_paginate = get_music_data.paginate(page: params[:page], per_page: 10)
	end
	def create
		row_timespan = params[:timespan]
		@music_data = get_music_data
		approve_index = @music_data.index{ |item| item[0] == row_timespan }
		approve_row(approve_index)
		redirect_back fallback_location: {action: "index"}
	end
	def get_music_data
		Rails.cache.fetch('music_data:', exprise_in: 12.seconds) {
			gg_service = GoogleSheetService.new
			gg_service.read
		}
	end
	def approve_row(row)
		gg_service = GoogleSheetService.new
		gg_service.write(row + 2, 4, 1)
		@music_data[row][3] = 1
	end
end