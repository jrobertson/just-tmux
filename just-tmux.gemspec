Gem::Specification.new do |s|
  s.name = 'just-tmux'
  s.version = '0.1.5'
  s.summary = 'just-tmux'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('dynarex')
  s.signing_key = '../privatekeys/just-tmux.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/just-tmux'
end
