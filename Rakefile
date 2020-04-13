task :default => [:compile_wasm]

task :compile_wasm => [:compile_mruby, "build"] do
  if system("which emcc", err: File::NULL, out: File::NULL)
    app = "build/app.c"
    sh "mruby/build/host/bin/mrbc", "-Bruby_app", "-o", app, "bin/jumping_chess"
    sh "cat mruby_main.c >> #{app}"
    sh "emcc",
      "-s", "WASM=1",
      "-I", "mruby/include",
      "--shell-file", "template.html",
      "-o", "build/app.html",
      app, "mruby/build/emscripten/lib/libmruby.a"
  else
    puts "emcc not available, skipping WASM build."
    puts "'source ~/code/emsdk/emsdk_env.sh' should add emcc in PATH"
  end
end

directory "build"

task :compile_mruby => ["mruby"] do
  sh "cd mruby && MRUBY_CONFIG=#{Dir.pwd}/mruby_build_config.rb ./minirake -j8"
  rm_f "bin/mruby"
  ln_s "../mruby/build/host/bin/mruby", "bin/mruby"
end

file "mruby" do
  sh "git clone https://github.com/mruby/mruby.git"
end

task :serve do
  exec RbConfig.ruby, '-run', '-e', 'httpd', '--', '--bind-address=127.0.0.1', '--port=8000', './build'
end

task :clean do
  sh "cd mruby && git clean -Xdf"
  rm_f "bin/mruby"
  sh "cd build && git clean -Xdf"
end
