class Set
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :entity

  field :name, type: String

  validates :name, presence: true, length: {minimum: 2}

  def to_s
    name.html_safe
  end
end
