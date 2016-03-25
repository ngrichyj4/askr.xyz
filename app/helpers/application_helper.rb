module ApplicationHelper
	def uniq_voters
		@poll.uniq_voters == 1 ? "1 person voted" : "#{@poll.uniq_voters} people voted"
	end
end
