namespace :initialvals do
	desc "Add global configs"
	task :configs => :environment do
		gconfs = AppConfig.setinitialvals
		
	end

	desc "Add initial values for all sections"
	task :all => [:configs]
end