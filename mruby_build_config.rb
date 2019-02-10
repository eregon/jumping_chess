MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'
  conf.gem __dir__
  conf.gem github: 'iij/mruby-mtest'
end
