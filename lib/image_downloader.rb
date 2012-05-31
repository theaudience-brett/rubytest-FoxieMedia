class ImageDownloader < Struct.new(:artwork_id)
  def perform
    artwork = ShowArtwork.find(artwork_id)
    puts artwork
    if artwork.download_image
      puts "Made it past the download"
      artwork.process = 3
      artwork.save
    end
  end
end