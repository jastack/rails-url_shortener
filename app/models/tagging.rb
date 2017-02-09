# == Schema Information
#
# Table name: taggings
#
#  id               :integer          not null, primary key
#  tag_topic_id     :integer
#  shortened_url_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Tagging < ActiveRecord::Base
  validates :shortened_url_id, presence: true
  validates :tag_topic_id, presence: true

  belongs_to :tag_topic,
    class_name: :TagTopic,
    primary_key: :id,
    foreign_key: :tag_topic_id

  belongs_to :shortened_url,
    class_name: :ShortenedUrl,
    primary_key: :id,
    foreign_key: :shortened_url_id

end
