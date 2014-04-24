class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy]

  autocomplete :entity, :title, :full => true

  # GET /entities
  # GET /entities.json
  def index
    @entities = Entity.any_of( { :title => /.*#{params[:search]}.*/i } )
  end

  # GET /entities/1
  # GET /entities/1.json
  def show  
    @link = Link.new
  end

  # GET /entities/new
  def new
    @entity = Entity.new
  end

  # GET /entities/1/edit
  def edit
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity = Entity.find_my_title( entity_params[:title] )

    if @entity.nil?
      @entity = Entity.new(entity_params)
    else
      @entity.update(entity_params)
    end

    respond_to do |format|
      if @entity.save
        format.html { redirect_to '/', notice: 'Entidad creada.' }
        format.json { render action: 'show', status: :created, location: @entity }
      else
        format.html { render action: 'new' }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to @entity, notice: 'Entidad actualizada.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    @entity.destroy
    respond_to do |format|
      format.html { redirect_to entities_url }
      format.json { head :no_content }
    end
  end

  # GET /map.json
  def map
    @entities = Entity.all
    @links = Link.all
    
    @son = {}
    @son['nodes'] = []
    @son['links'] = []

    @indexs = {}
    i=0

    @entities.each do |ent|
      @indexs[ent.id.hash.abs] = i
      if ent.meta.length > 0 
        @son['nodes'].push( {index: i, name: ent.title, meta: Metum.for_export(ent.meta) } )
      else
        @son['nodes'].push( {index: i, name: ent.title} )
      end
      i = i + 1
    end

    @links.each do |link|
      if link.meta.length > 0 
        @son['links'].push( {source: @indexs[link.ent_a.id.hash.abs], target: @indexs[link.ent_b.id.hash.abs], meta: Metum.for_export(link.meta)} )
      else
        @son['links'].push( {source: @indexs[link.ent_a.id.hash.abs], target: @indexs[link.ent_b.id.hash.abs]} )
      end
    end

    render json: @son
  end

  # GET /import
  def import
  end

  # POST /import
  # Esta primer verison del importador esta muy muy fea
  def doimport
    json = JSON.parse(params[:json])
    nodes = []

    # Import entities
    json['nodes'].each do |node|
      entity = Entity.find_my_title(node['name'])

      # Entity data
      if entity.nil? 
        entity = Entity.new
        entity.title = node['name']
        entity.save()
      end

      # Entity metadata
      if node['meta'].present?
        node['meta'].each do |meta|
          entity.add_meta(meta['key'] , meta['value'] , false)
        end
      end

      nodes[node['index']] = entity
    end

    # Import links
    json['links'].each do |link_ar|
      source = nodes[link_ar['source']]
      target = nodes[link_ar['target']]
      link = Link.find_my_link(source,target)

      if link.nil? 
        link = Link.new
        link.ent_a = source
        link.ent_b = target
        link.save()
      end

      # Link metadata
      if link_ar['meta'].present?
        link_ar['meta'].each do |meta|
          link.add_meta(meta['key'] , meta['value'] , false)
        end
      end
    end
    redirect_to '/'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:title,meta_attributes: [:key, :value] )
    end
end
