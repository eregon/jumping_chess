MRuby::Gem::Specification.new('mruby-jumping-chess') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Benoit Daloze'

  spec.add_dependency 'mruby-kernel-ext'
  spec.add_dependency 'mruby-string-ext'
  spec.add_dependency 'mruby-numeric-ext'
  spec.add_dependency 'mruby-array-ext'
  spec.add_dependency 'mruby-enumerator'
  spec.add_dependency 'mruby-io'
  spec.add_dependency 'mruby-math'
  spec.add_dependency 'mruby-metaprog'
end
