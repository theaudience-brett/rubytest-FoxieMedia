require 'nokogiri'
require 'open-uri'
require 'delayed_job'

class ShowsController < ApplicationController

  before_filter :check_user, :only => [:find, :find_results, :new, :edit, :create, :update, :destrpy, :populate]
  # GET /shows
  # GET /shows.json
  def index
    if signed_in?
      @shows = current_user.shows
    else
      @shows = Show.find_all_by_public(1)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shows }
    end
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @show = Show.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/find
  def find
    @show = Show.new

    if !signed_in?
      flash[:error] = "You need to be signed in before you can add a new show."
      redirect_to login_path
    end
  end

  def find_results
    @title = params[:title]
    @shows = Show.find_show(@title)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shows, :layout => false }
    end
  end

  # GET /shows/new
  # GET /shows/new.json
  def new
    @show = Show.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @show }
    end
  end

  # GET /shows/1/edit
  def edit
    @show = Show.find(params[:id])
  end

  # POST /shows
  # POST /shows.json
  def create
    @showexists = Show.find_by_tvdb_id(params[:show][:tvdb_id])
    if @showexists
      if @showexists.users.exists?(:id => current_user.id)
        puts "We found the show and it's already part of the users collection. Skipping"
        flash[:notice] = "Show #{@showexists.title} is already part of your collection"
        redirect_to shows_path
      else
        puts "We found the show, but not for the current user. Add to users shows"
        @showexists.shows_users.create(:show_id => @showexists.id,
                                       :user_id => current_user.id,
                                       :show_artwork_id => ShowArtwork.default_poster(@showexists.id).id,
                                       :location => '')
        #@showexists.shows_users.first.show_artwork_id = ShowArtwork.default_poster(@showexists.id).id
        @showexists.save
        flash[:success] = "Added show #{@showexists.title} to your list of shows."
        redirect_to shows_path
      end
    else
      @show = Show.new(params[:show])
      if @show.save
        puts "Added a new show and associated it with the current user."
        redirect_to populate_url(:id => @show.id), notice: 'Show added, now importing data.'
      else
        puts "Error adding the show. Back to the beginning"
        render action: "new"
      end
    end

  end

  # PUT /shows/1
  # PUT /shows/1.json
  def update
    @show = Show.find(params[:id])

    respond_to do |format|
      if @show.update_attributes(params[:show])
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show = Show.find(params[:id])
    @show.destroy

    respond_to do |format|
      format.html { redirect_to shows_url }
      format.json { head :no_content }
    end
  end

  # GET /show/1/populate
  def populate
    @show = Show.find(params[:id])
    puts @show
    @show.import_data( current_user )
    @show.shows_users.create(:show_id => @show.id,
                             :user_id => current_user.id,
                             :show_artwork_id => ShowArtwork.default_poster(@show.id).id,
                             :location => '')
  end

  def userconfig
    @show = Show.find(params[:id])
    #Don't display anything in the users never download list
    never_download = current_user.settings.artwork[:never_download]

    @artwork = @show.get_image_group(never_download)
  end

  private

  def check_user
    redirect_to login_path unless signed_in?
  end
end
