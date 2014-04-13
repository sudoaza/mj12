module FormHelper

  def setup_entity(entity)
    entity.meta.build
    entity
  end

  def setup_link(link)
    link.meta.build

    if link.ent_a_id.present? 
      link.ent_a = Entity.find(link.ent_a_id)
    else 
      link.ent_a = Entity.new
    end

    if link.ent_b_id.present?
      link.ent_b = Entity.find(link.ent_b_id)
    else
      link.ent_b = Entity.new
    end

    link
  end


end
