class Entity
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :meta

  has_many :a_links, :class_name => 'Link', :foreign_key => 'ent_a_id'
  has_many :b_links, :class_name => 'Link', :foreign_key => 'ent_b_id'

  field :title, type: String

  validates :title, presence: true, length: {minimum: 2}

  accepts_nested_attributes_for :meta, :reject_if => :all_blank

  def link
    s = '<a href="/entities/' + self.id + '">' + self.title + '</a>'
  end
end
