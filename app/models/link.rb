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
    if self.ent_a.present?
      s = self.ent_a.link
    end
    s = s + ' &lt;-&gt; ' 
    if self.ent_b.present?
      s = s + self.ent_b.link
    end
    s
  end

  def self.find_my_link(a_id, b_id)
    self.find_by ent_a_id: a_id, ent_b_id: b_id
  end
end
