class Metum
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :entity
  belongs_to :link

  field :key, type: String
  field :value, type: String

  validates :key, :value, presence: true, length: {minimum: 2}
  def to_s
    s = '<strong>' + self.key + ':</strong> ' + self.value
    s.html_safe
  end
end
