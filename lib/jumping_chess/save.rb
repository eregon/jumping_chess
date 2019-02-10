class Save
  def initialize
    @logdir = File.expand_path("../../../log", __FILE__)
    Dir.mkdir(@logdir) unless File.directory?(@logdir)

    if RUBY_ENGINE == "mruby"
      @path = "#{@logdir}/#{Time.now}R#{rand(1<<16)}.log"
      @file = File.open(@path, "w")
    else
      @path = "#{@logdir}/#{Time.now.strftime('%FT%H-%M-%S')}P#{$$}.log"
      @file = File.open(@path, File::CREAT | File::EXCL | File::WRONLY)
    end
    @file.sync = true
  end

  def record(action)
    @file.puts action.join(" ")
  end

  def self.load(file)
    File.foreach(file, chomp: true) { |line|
      yield line.split(" ").map { |c| COORDS_BY_NAME[c] }
    }
  end
end
