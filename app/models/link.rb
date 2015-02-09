class Link
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :meta

  belongs_to :ent_a, :class_name=>'Entity', :inverse_of => :a_links
  belongs_to :ent_b, :class_name=>'Entity', :inverse_of => :b_links

  validates :ent_a_id, :ent_b_id, presence: true

  accepts_nested_attributes_for :meta, :reject_if => :all_blank
  accepts_nested_attributes_for :ent_a
  accepts_nested_attributes_for :ent_b

  def to_s
    s = ''
    s = self.ent_a.link if self.ent_a.present?
    s = s + ' &lt;-&gt; '
    s = s + self.ent_b.link if self.ent_b.present?
  end

  def self.find_my_link(a_id, b_id)
    self.find_by ent_a_id: a_id, ent_b_id: b_id
  end

  def add_meta( key, value, override = true )
    added = false
    self.meta.each do |meta|
      if meta.key == key
        if meta.value == value 
          added = true
        elsif override
          meta.value = value
          added = true
        end
      end
    end
    if ! added 
      meta = Metum.new
      meta.key = key
      meta.value = value
      self.meta.push(meta)
    end
    self.save()
  end

end
