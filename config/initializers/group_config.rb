class GroupConfig

	def self.get(sect)
		@groupconf = {:id => sect}
		@groupconf[:fields] = {}
		AppConfig.where(:section => sect).each do |conf|
			@groupconf[:fields][conf.confkey] = conf.confval
		end

		@groupconf
	end

	def self.update(existing, formvals)
		existing[:fields].each { |key, val| 
			if formvals[key] and formvals[key] != val
				config = AppConfig.where(:confkey => key, :section => existing[:id]).first
				config[:confval] = formvals[key]
				config.save
			end
		}
	end
end