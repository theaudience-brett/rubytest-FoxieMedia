class ShowArtworksController < ApplicationController
  # GET /show_artworks
  # GET /show_artworks.json
  def index
    @show_artworks = ShowArtwork.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @show_artworks }
    end
  end

  # GET /show_artworks/1
  # GET /show_artworks/1.json
  def show
    @show_artwork = ShowArtwork.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @show_artwork }
    end
  end

  # GET /show_artworks/new
  # GET /show_artworks/new.json
  def new
    @show_artwork = ShowArtwork.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @show_artwork }
    end
  end

  # GET /show_artworks/1/edit
  def edit
    @show_artwork = ShowArtwork.find(params[:id])
  end

  # POST /show_artworks
  # POST /show_artworks.json
  def create
    @show_artwork = ShowArtwork.new(params[:show_artwork])

    respond_to do |format|
      if @show_artwork.save
        format.html { redirect_to @show_artwork, notice: 'Show artwork was successfully created.' }
        format.json { render json: @show_artwork, status: :created, location: @show_artwork }
      else
        format.html { render action: "new" }
        format.json { render json: @show_artwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /show_artworks/1
  # PUT /show_artworks/1.json
  def update
    @show_artwork = ShowArtwork.find(params[:id])

    respond_to do |format|
      if @show_artwork.update_attributes(params[:show_artwork])
        format.html { redirect_to @show_artwork, notice: 'Show artwork was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @show_artwork.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /show_artworks/1
  # DELETE /show_artworks/1.json
  def destroy
    @show_artwork = ShowArtwork.find(params[:id])
    @show_artwork.destroy

    respond_to do |format|
      format.html { redirect_to show_artworks_url }
      format.json { head :no_content }
    end
  end
end
