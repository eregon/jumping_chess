task :default => [:compile_mruby]

task :compile_mruby => ["mruby"] do
  sh "cd mruby && MRUBY_CONFIG=#{Dir.pwd}/mruby_build_config.rb ./minirake -j8"
  rm_f "bin/mruby"
  ln_s "../mruby/build/host/bin/mruby", "bin/mruby"
end

file "mruby" do
  sh "git clone https://github.com/mruby/mruby.git"
end

task :clean do
  sh "cd mruby && git clean -Xdf"
  rm_f "bin/mruby"
end
