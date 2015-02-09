class Entity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :set
  has_many :meta
  has_many :a_links, :class_name => 'Link', :foreign_key => 'ent_a_id'
  has_many :b_links, :class_name => 'Link', :foreign_key => 'ent_b_id'

  field :title, type: String

  validates :title, presence: true, length: {minimum: 2}

  accepts_nested_attributes_for :meta, :reject_if => :all_blank

  def self.find_my_title( title ) 
    self.find_by title: title
  end

  def link
    s = '<a href="/entities/' + self.id + '">' + self.title + '</a>'
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
