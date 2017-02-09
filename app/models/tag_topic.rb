# == Schema Information
#
# Table name: tag_topics
#
#  id         :integer          not null, primary key
#  topic      :string
#  created_at :datetime
#  updated_at :datetime
#

class TagTopic < ActiveRecord::Base
  validates :topic, presence: true, uniqueness: true

  has_many :taggings,
    class_name: :Tagging,
    primary_key: :id,
    foreign_key: :tag_topic_id

  has_many :shortened_urls,
    through: :taggings,
    source: :shortened_url

  def popular_links
    shortened_urls.sort_by { |s| s.num_clicks }.reverse[0..4]
  end
end
