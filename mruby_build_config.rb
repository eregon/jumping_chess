def add_gems(conf)
  conf.gembox 'default'
  conf.gem __dir__
  conf.gem github: 'iij/mruby-mtest'
end

MRuby::Build.new do |conf|
  toolchain :gcc

  add_gems(conf)
end

if system("which emcc", err: File::NULL, out: File::NULL)
  MRuby::CrossBuild.new('emscripten') do |conf|
    toolchain :clang
    conf.cc.command = 'emcc'
    conf.cc.flags = %w[-Os]
    conf.linker.command = 'emcc'
    conf.archiver.command = 'emar'

    add_gems(conf)
  end
end
