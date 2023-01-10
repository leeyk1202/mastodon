redirect_uri = 'https://wallet.hello.coop/oauth/response/mastodon/'
if ENV['HELLO_MASTODON_BUILDER_REDIRECT_URI']
  redirect_uri = ENV['HELLO_MASTODON_BUILDER_REDIRECT_URI']
end

client_secret = nil
if ENV['HELLO_MASTODON_BUILDER_CLIENT_SECRET']
  client_secret = ENV['HELLO_MASTODON_BUILDER_CLIENT_SECRET']
end

Doorkeeper::Application.create(
  name: 'Hellō Mastodon Builder',
  uid: 'hello-mastodon-builder',
  secret: client_secret,
  redirect_uri: redirect_uri,
  scopes: 'read write follow',
  website: 'https://hello.coop/',
  owner_type: 'User',
  owner_id: 1
)

Rule.create(text: 'Be kind. Don''t be mean, nasty, abusive, sexist, racist, or offensive. No shitposting. No doxing. Engage in healthy debate if inclined.')
Rule.create(text: 'Be legal. Don''t post material illigal in either the US, or where you are located. Abide by all applicable laws. We will cooperate with law enforcement when legally required to.')
Rule.create(text: 'Use your real name, IE the name that others know you as. Don''t pretend to be someone else. User another Mastodon instance if you want pseudonymity or anonymity.')


category = CustomEmojiCategory.find_or_create_by(name: 'System')

Dir.glob('lib/assets/hello/emoji/*.png') do |filename|
  shortcode = File.basename(filename, '.*')
  image_data = File.read(filename)

  e = CustomEmoji.new(shortcode: shortcode, domain: nil)
  e.image = StringIO.new(image_data)
  e.image_file_name = File.basename(filename)
  e.visible_in_picker = true
  e.category = category

  e.save
end
