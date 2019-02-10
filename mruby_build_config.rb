MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'
  conf.gem core: 'mruby-eval'
end
