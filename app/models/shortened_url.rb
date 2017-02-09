# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, presence: true, uniqueness: true
  validates :short_url, presence: true, uniqueness: true
  validates :user_id, presence: true
  validate :no_spamming, :nonpremium_max

  belongs_to :submitter,
    class_name: :User,
    primary_key: :id,
    foreign_key: :user_id

  has_many :visits,
    dependent: :destroy,
    class_name: :Visit,
    primary_key: :id,
    foreign_key: :shortened_url_id

  has_many :visitors,
    dependent: :destroy,
    -> { distinct },
    through: :visits,
    source: :user

  has_many :taggings,
    dependent: :destroy,
    class_name: :Tagging,
    primary_key: :id,
    foreign_key: :shortened_url_id

  has_many :tag_topics,
    dependent: :destroy,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    short_url = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(:short_url)
      short_url = SecureRandom.urlsafe_base64
    end
    short_url
  end

  def self.shorten(user, long_url)
    ShortenedUrl.create!(
      long_url: long_url,
      short_url: ShortenedUrl.random_code,
      user_id: user.id
    )
  end

  def self.prune(n)
    shiny = Visit.select('shortened_url_id').where("created_at > ?", n.minutes.ago)
    shiny = shiny.map { |obj| obj.shortened_url_id }

    dusty = ShortenedUrl.where.not(id: shiny)
    dusty.each { |su| su.delete }
    dusty
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("visits.created_at > ?", 10.minutes.ago).count
  end

  def no_spamming
    most_recent = ShortenedUrl.order("created_at DESC").limit(5)

    return true if most_recent.length < 5

    if most_recent.all? { |su| su.created_at >= 1.minute.ago }
      self.errors[:spam] << "too many url requests"
      false
    else
      true
    end
  end

  def nonpremium_max
    this_user = User.find_by(id: user_id)
    unless this_user.premium
      total_urls = this_user.submitted_urls.count

      if total_urls >= 5
        self.errors[:nonpremium] << "reached nonpremium limit :("
        false
      else
        true
      end
    end
  end

end
