MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'
  conf.gem core: 'mruby-eval'
  conf.gem github: 'iij/mruby-mtest'
end
