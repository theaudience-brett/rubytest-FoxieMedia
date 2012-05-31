module BmConfig
	class Base
		
		include ActiveModel::AttributeMethods
		include ActiveModel::Conversion
		extend ActiveModel::Naming
		extend ActiveModel::Translation
		include ActiveModel::Validations

		def self.attributes(*names)
			attr_accessor *names

		end

		def persisted?
			false
		end
	end
end