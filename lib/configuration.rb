require "optparse"
require "pathname"

class Configuration
  def self.call(...)
    new(...).config
  end

  # @param argv [Array]
  def initialize(argv)
    @argv = argv
    @config = defaults
  end

  # @return [Configuration]
  def config
    OptionParser.new do |parser|
      parser.on("--[no-]csv", "Generate CSV file (default is --csv)")
      parser.on("--[no-]others", "Include non-Login items in report (default is --others)")
      parser.on("--[no-]stdout", "Send CSV to standard output (default is --no-stdout)")
      parser.on("--in DIRECTORY", "Location of reports to process (default is $HOME/Downloads)")
    end.parse(@argv, into: @config)

    (csv? || stdout?) or raise("no output configured")

    self
  end

  def csv?
    @config.fetch(:csv)
  end

  def in
    Pathname.new(@config.fetch(:in))
  end

  def others?
    @config.fetch(:others)
  end

  def stdout?
    @config.fetch(:stdout)
  end

  private

  def defaults
    {
      csv: true,
      in: Pathname.new(Dir.home).join("Downloads").to_s,
      others: true,
      stdout: false,
    }
  end
end
