version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name        = 'killbill-paypal-express'
  s.version     = version
  s.summary     = 'Plugin to use Express Checkout as a gateway.'
  s.description = 'Killbill payment plugin for Paypal Express Checkout.'

  s.required_ruby_version = '>= 1.9.3'

  s.license = 'Apache License (2.0)'

  s.author   = 'Killbill core team'
  s.email    = 'killbilling-users@googlegroups.com'
  s.homepage = 'http://www.killbilling.org'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.bindir        = 'bin'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options << '--exclude' << '.'

  s.add_dependency 'killbill', '~> 1.0.11'
  s.add_dependency 'activemerchant', '~> 1.31.1'
  s.add_dependency 'activerecord', '~> 3.2.1'
  s.add_dependency 'sinatra', '~> 1.3.4'

  s.add_development_dependency 'jbundler', '~> 0.4.1'
  s.add_development_dependency 'rake', '>= 10.0.0'
  s.add_development_dependency 'rspec', '~> 2.12.0'
  if defined?(JRUBY_VERSION)
    s.add_development_dependency 'activerecord-jdbcsqlite3-adapter', '~> 1.2.6'
  else
    s.add_development_dependency 'sqlite3', '~> 1.3.7'
  end
end