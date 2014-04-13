class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create

    # Load the link if it already exists
    @link = Link.find_by ent_a_id: link_params[:ent_a_attributes][:id], ent_b_id: link_params[:ent_b_attributes][:id]
    if @link.nil?
      @link = Link.find_by ent_a_id: link_params[:ent_b_attributes][:id], ent_b_id: link_params[:ent_a_attributes][:id]
    end

    if @link.nil? 
      @link = Link.new(link_params)
      @link.ent_a_id = link_params[:ent_a_attributes][:id]
      @link.ent_b_id = link_params[:ent_b_attributes][:id]
    else
      @link.update(link_params)
    end

    respond_to do |format|
      if @link.save
        format.html { redirect_to "/", notice: 'Relacion creada.' }
        format.json { render action: 'show', status: :created, location: @link }
      else
        format.html { render action: 'new' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Relacion actualizada.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
      @link.ent_a = Entity.find(@link.ent_a_id)
      @link.ent_b = Entity.find(@link.ent_b_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params[:link].permit( meta_attributes: [:key, :value], ent_a_attributes: [:id], ent_b_attributes: [:id] )
    end
end
