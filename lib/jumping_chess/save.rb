class Save
  def initialize
    @logdir = File.expand_path("../../log", __dir__)
    Dir.mkdir(@logdir) unless Dir.exist?(@logdir)

    @path = "#{@logdir}/#{Time.now.strftime('%FT%H-%M-%S')}P#{$$}.log"
    @file = File.open(@path, File::CREAT | File::EXCL | File::WRONLY)
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
