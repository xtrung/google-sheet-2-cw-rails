require "google_drive"

class GoogleSheetService
	def initialize()
		@session = GoogleDrive::Session.from_config("config.json")
		@ws = @session.spreadsheet_by_key(ENV["SHEET_ID"]).worksheets[0]
	end
	def read
		(1..@ws.num_rows).each do |row|
  			(1..@ws.num_cols).each do |col|
    			p @ws[row, col]
  			end
		end
	end
end
