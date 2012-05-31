require 'nokogiri'
require 'open-uri'
require 'zip/zipfilesystem'
require 'uri'

class Show < ActiveRecord::Base
	has_many :episodes, :dependent => :destroy
	has_many :show_artworks, :dependent => :destroy
	belongs_to :show_artwork
  has_many :shows_users
  has_many :users, :through => :shows_users
  accepts_nested_attributes_for :shows_users

  validates_uniqueness_of :tvdb_id, :case_sensitive => false


	def self.find_show(name)
		name = URI.escape(name)
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

  def get_image_group( skiptype = [] )
    imggroups = self.show_artworks.select("DISTINCT basetype").all(:conditions => ["basetype NOT IN (?)", skiptype])
    @imghash = Hash.new

    imggroups.each do |i|
      @imghash[i.basetype] = self.show_artworks.where(:basetype => i.basetype)
    end

    @imghash
  end

	def import_data( user )
    @user ||= user

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
		
		puts "Filling episode table with contents from xml"
		import_episodes_from_xml("tmp/#{tvdb_id}/episodes.xml", id)
		puts "Grab all available artwork"
		import_artwork_from_xml("tmp/#{tvdb_id}/banners.xml", id)
		puts "Grabbing further details about the show"
		get_full_show_details("tmp/#{tvdb_id}/episodes.xml", id)
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
			show_hash[:show_artwork_id] = ShowArtwork.select_artwork(ShowArtwork.where(:show_id => showid, :basetype => 'poster').first.id)
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

	def import_artwork_from_xml(filename, showid)

		artwork_xml = Nokogiri::XML.parse(open(filename))
		artwork_xml.xpath('/Banners/Banner').each do |art|

			artwork_hash = {}
			artwork_hash[:show_id] = showid
			artwork_hash[:tvdb_id] = art.at_xpath('id').text
			artwork_hash[:path] = art.at_xpath('BannerPath') ? art.at_xpath('BannerPath').text : nil
			artwork_hash[:basetype] = art.at_xpath('BannerType') ? art.at_xpath('BannerType').text : nil
			artwork_hash[:subtype] = art.at_xpath('BannerType2') ? art.at_xpath('BannerType2').text : nil
			artwork_hash[:language] = art.at_xpath('Language') ? art.at_xpath('Language').text : nil
			artwork_hash[:rating] = art.at_xpath('Rating') ? art.at_xpath('Rating').text : 0
			artwork_hash[:thumbnail] = art.at_xpath('ThumbnailPath') ? art.at_xpath('ThumbnailPath').text : nil
      if @user.settings.artwork[:auto_download] && @user.settings.artwork[:auto_download].include?(artwork_hash[:basetype])
        artwork_hash[:process] = 2
      elsif @user.settings.artwork[:user_download] && @user.settings.artwork[:user_download].include?(artwork_hash[:basetype])
        artwork_hash[:process] = 1
      end

			show = ShowArtwork.create(artwork_hash)
      Delayed::Job.enqueue(ImageDownloader.new(show.id)) if artwork_hash[:process] == 2
		end
	end

	def get_nice_episode_list
		seasonlist = self.episodes.select(:season_no).uniq.order('season_no ASC')
		seasonarr = []

		seasonlist.each do |se|
			tmparr = []
			seasoneps = self.episodes.where("season_no = ?", se.season_no).order('episode_no DESC')
			seasoneps.each do |sep|
				tmparr.push(sep)
			end
			sectionname = se.season_no == 0 ? "Specials" : "Season #{se.season_no}"
			seasonarr.push({ "#{sectionname}" => tmparr })
		end

		seasonarr
	end
end
