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

	def edit
		row_timespan = params[:id]
		@music = get_music_data.select { |item| item[0] == row_timespan }.first
	end

	def update
		row_timespan = params[:id]
		@music_data ||= get_music_data
		approve_index = @music_data.index{ |item| item[0] == row_timespan }
		update_row(approve_index, params)
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
		gg_service.write(row + 1, 4, 1)
		@music_data[row][3] = 1
	end

	def update_row(row, data)
		gg_service = GoogleSheetService.new
		gg_service.write(row + 1, 2, data[:name])
		gg_service.write(row + 1, 3, data[:content])
		gg_service.write(row + 1, 4, data[:is_approve])
		@music_data[row][1] = data[:name]
		@music_data[row][2] = data[:content]
		@music_data[row][3] = data[:is_approve]
	end

end