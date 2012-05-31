require 'test_helper'

class GlobalConfigTest < ActiveSupport::TestCase
	include ActiveModel::Lint::Tests 

	def setup
		@model = AppConfig.new
	end
end
