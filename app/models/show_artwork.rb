require 'fileutils'
require 'open-uri'

class ShowArtwork < ActiveRecord::Base
	#has_one :show
  has_one :shows_user

  def self.default_poster(showid, options = { :imgtype => 'poster', :orderby => 'id' } )
    defaultart =  where(:show_id => showid, :basetype => options[:imgtype]).first
  end

	def self.select_artwork(artid)
		art = ShowArtwork.find(artid)
		retval = nil
		if art and art.path
			if self.download_art(art.path)
				retval = art.id
			end
		end
		
		retval
	end

	def self.download_art(imgpath)
		patharr = imgpath.split('/')
		filename = patharr.pop()
		basepath = patharr.join('/')
		puts basepath
		FileUtils.mkdir_p "./public/images/artwork/full/#{basepath}" unless File.directory?("./public/images/artwork/full/#{basepath}")
		localimg = open("./public/images/artwork/full/#{basepath}/#{filename}", "wb")
		localimg.write(open("http://thetvdb.com/banners/#{imgpath}").read)
		localimg.close
    localimg
  end

  def download_image
    patharr = self.path.split('/')
    puts patharr
    filename = patharr.pop()
    basepath = patharr.join('/')
    puts basepath
    FileUtils.mkdir_p "./public/images/artwork/full/#{basepath}" unless File.directory?("./public/images/artwork/full/#{basepath}")
    localimg = open("./public/images/artwork/full/#{basepath}/#{filename}", "wb")
    localimg.write(open("http://thetvdb.com/banners/#{self.path}").read)
    localimg.close
    localimg
  end

end
