MRuby::Build.new do |conf|
  toolchain :gcc
  conf.cc.defines += %w[MRUBY_PLATFORM=host]

  conf.gem __dir__
  conf.gem core: 'mruby-bin-mruby'
  conf.gem github: 'iij/mruby-mtest'
end

if system("which emcc", err: File::NULL, out: File::NULL)
  MRuby::CrossBuild.new('emscripten') do |conf|
    toolchain :clang
    conf.cc.defines += %w[MRUBY_PLATFORM=wasm]

    conf.cc.command = 'emcc'
    conf.cc.flags = %w[-Os]
    conf.linker.command = 'emcc'
    conf.archiver.command = 'emar'

    conf.gem __dir__
  end
end
