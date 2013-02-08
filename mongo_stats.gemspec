Gem::Specification.new do |s|
  s.name        = 'mongo_stats'
  s.version     = '0.0.5'
  s.date        = '2013-01-18'
  s.summary     = "Simple thingy for recording stats!"
  s.description = "A simple hello world gem"
  s.authors     = ["Julian Russell"]
  s.email       = 'julian@myfoodlink.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/plusplus/mongo-stats'
  s.add_runtime_dependency 'mongo', '~> 1.1'
end
