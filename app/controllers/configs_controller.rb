class ConfigsController < ApplicationController
  # GET /configs
  # GET /configs.json
  def index
    @sect = params[:sect] ? params[:sect] : 'general'

    site_configs

    puts @site_configs

    testval = get_conf_value("STORE_SEASON").confval



    puts "PLEASE WORK: #{testval}"

    apply_user_confs(current_user.get_configs)

    testval = get_conf_value("STORE_SEASON").confval



    puts "PLEASE WORK: #{testval}"

    @global_configs = AppConfig.where(:section => @sect)

    @global_config = GroupConfig.get(@sect)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @global_configs }
    end
  end

  # GET /configs/1
  # GET /configs/1.json
  def show
    @global_config = AppConfig.where(:section => params[:sect])
    @global_config.each do |conf|
      puts conf.confkey
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @global_config }
    end
  end

  # GET /configs/new
  # GET /configs/new.json
  def new
    @global_config = AppConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @global_config }
    end
  end

  # GET /configs/1/edit
  def edit
    @global_config = AppConfig.find(params[:id])
  end

  # POST /configs
  # POST /configs.json
  def create
    @global_config = AppConfig.new(params[:global_config])

    respond_to do |format|
      if @global_config.save
        format.html { redirect_to @global_config, notice: 'Global config was successfully created.' }
        format.json { render json: @global_config, status: :created, location: @global_config }
      else
        format.html { render action: "new" }
        format.json { render json: @global_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /configs/1
  # PUT /configs/1.json
  def update
    @global_config = GroupConfig.get(params[:id])
    GroupConfig.update(@global_config, params)

    respond_to do |format|
      format.html { redirect_to @global_config, notice: 'Global config was successfully updated.' }
    end
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
    @global_config = AppConfig.find(params[:id])
    @global_config.destroy

    respond_to do |format|
      format.html { redirect_to global_configs_url }
      format.json { head :no_content }
    end
  end
end
