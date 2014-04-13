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
    s = self.ent_a.title + ' <-> ' + self.ent_b.title
  end
end
