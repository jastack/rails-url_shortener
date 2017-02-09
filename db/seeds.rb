# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u1 = User.new(email: 'email@email.com')
u2 = User.new(email: 'peloneous@hotmail.com')
u1.save!
u2.save!

s1 = ShortenedUrl.shorten(u1, 'www.github.com')
s2 = ShortenedUrl.shorten(u1, 'www.google.com')
s3 = ShortenedUrl.shorten(u2, 'www.nytimes.com')
s4 = ShortenedUrl.create(long_url: "weorndnais", short_url: "wernxs", user_id: 2)

t1 = TagTopic.new(topic: "Politics")
t2 = TagTopic.new(topic: "Sports")
t3 = TagTopic.new(topic: "Health")
t1.save!
t2.save!
t3.save!

tagging1 = Tagging.new(tag_topic_id: t1.id, shortened_url_id: s1.id)
tagging2 = Tagging.new(tag_topic_id: t1.id, shortened_url_id: s2.id)
tagging3 = Tagging.new(tag_topic_id: t2.id, shortened_url_id: s2.id)
tagging4 = Tagging.new(tag_topic_id: t2.id, shortened_url_id: s3.id)
tagging5 = Tagging.new(tag_topic_id: t3.id, shortened_url_id: s3.id)
tagging6 = Tagging.new(tag_topic_id: t3.id, shortened_url_id: s1.id)
tagging1.save!
tagging2.save!
tagging3.save!
tagging4.save!
tagging5.save!
tagging6.save!

Visit.record_visit!(u1, s1)
Visit.record_visit!(u2, s1)
Visit.record_visit!(u1, s1)
Visit.record_visit!(u2, s2)
Visit.record_visit!(u1, s3)
Visit.create(shortened_url_id: s4.id, user_id: 2, created_at: 100.minutes.ago)
