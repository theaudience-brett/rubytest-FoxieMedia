require 'nokogiri'
require 'open-uri'
require 'zip/zipfilesystem'

class Show < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy

	def self.find_show(name)
	    show_list = Nokogiri::XML.parse(open("http://www.thetvdb.com/api/GetSeries.php?seriesname=#{name}"))

	    series_array = Array.new

	    show_list.xpath('/Data/Series').each do |series|
	    	show_hash = {}
	    	show_hash[:id] = series.at_xpath('seriesid').text
	    	show_hash[:name] = series.at_xpath('SeriesName') ? series.at_xpath('SeriesName').text : ''
	    	show_hash[:overview] = series.at_xpath('Overview') ? series.at_xpath('Overview').text : ''
	    	show_hash[:aired] = series.at_xpath('FirstAired') ? series.at_xpath('FirstAired').text : ''

	    	series_array << show_hash
	    end

	    series_array
	end

	def import_data
		api_key = '89C970B29C8BAA1D'
		api_url = 'http://www.thetvdb.com/api/'

		puts "Creating tmp directory"
		Dir.mkdir("./tmp/#{tvdb_id}") unless File.directory?("./tmp/#{tvdb_id}")
		puts "Downloading zip file"
		dest = open("./tmp/#{tvdb_id}/en.zip", "wb")
		dest.write(open("#{api_url}#{api_key}/series/#{tvdb_id}/all/en.zip").read)
		dest.close
		puts "Unzipping file contents"
		Zip::ZipFile.open("tmp/#{tvdb_id}/en.zip") do |zipfile|
			actors = open("tmp/#{tvdb_id}/actors.xml", "wb")
			actors.write(zipfile.file.read("actors.xml"))
			actors.close

			banners = open("tmp/#{tvdb_id}/banners.xml", "wb")
			banners.write(zipfile.file.read("banners.xml"))
			banners.close

			episodes = open("tmp/#{tvdb_id}/episodes.xml", "wb")
			episodes.write(zipfile.file.read("en.xml"))
			episodes.close
		end
		puts "Grabbing further details about the show"
		get_full_show_details("tmp/#{tvdb_id}/episodes.xml", id)
		puts "Filling episode table with contents from xml"
		import_episodes_from_xml("tmp/#{tvdb_id}/episodes.xml", id)
	end

	def get_full_show_details(filename, showid)
		show_xml = Nokogiri::XML.parse(open(filename))
		show_xml.xpath('/Data/Series').each do |sh|
			show_hash = {}
			show_hash[:air_day] = sh.at_xpath('Airs_DayOfWeek') ? sh.at_xpath('Airs_DayOfWeek').text : ''
			show_hash[:air_time] = sh.at_xpath('Airs_Time') ? sh.at_xpath('Airs_Time').text : ''
			show_hash[:first_aired] = sh.at_xpath('FirstAired') ? sh.at_xpath('FirstAired').text : '0000-00-00'
			show_hash[:network] = sh.at_xpath('Network') ? sh.at_xpath('Network').text : ''
			show_hash[:rating] = sh.at_xpath('Rating') ? sh.at_xpath('Rating').text : '0'
			show_hash[:status] = sh.at_xpath('Status') ? sh.at_xpath('Status').text : ''
			show_hash[:poster] = sh.at_xpath('poster') ? sh.at_xpath('poster').text : ''
			update_attributes(show_hash)
		end
	end

	def import_episodes_from_xml(filename, showid)
		episodes_xml = Nokogiri::XML.parse(open(filename))
		episodes_xml.xpath('/Data/Episode').each do |ep|
			episode_hash = {}
			episode_hash[:show_id] = showid
			episode_hash[:tvdb_id] = ep.at_xpath('id').text
			episode_hash[:season_no] = ep.at_xpath('SeasonNumber') ? ep.at_xpath('SeasonNumber').text : 0
			episode_hash[:episode_no] = ep.at_xpath('EpisodeNumber') ? ep.at_xpath('EpisodeNumber').text : 0
			episode_hash[:episode_name] = ep.at_xpath('EpisodeName') ? ep.at_xpath('EpisodeName').text : ''
			episode_hash[:first_aired] = ep.at_xpath('FirstAired') ? ep.at_xpath('FirstAired').text : '1999-01-01'
			episode_hash[:overview] = ep.at_xpath('Overview') ? ep.at_xpath('Overview').text : ''
			episode_hash[:last_update] = ep.at_xpath('lastupdated') ? ep.at_xpath('lastupdated').text : 0
			
			Episode.create(episode_hash)
		end
	end
end
