require "pathname"

class ReportCollector
  ONE_PASSWORD_USER_REPORT_FILENAME_PATTERN = /User Report [1-9]\d{3}-\d\d-\d\d\.csv\z/

  def self.call(...)
    new(...).reports
  end

  # @param config [Configuration]
  def initialize(config)
    @config = config
  end

  # @raise [RuntimeError]
  # @return [Array<(Configuration, Array<Pathname>)>]
  def reports
    pathname = @config.in
    pathname.exist? or raise("#{pathname.inspect} does not exist")
    pathname.directory? or raise("#{pathname.inspect} is not a directory")

    _reports = pathname
      .children
      .select { |c| c.basename.to_s.match?(ONE_PASSWORD_USER_REPORT_FILENAME_PATTERN) }
      .select(&:readable?)
      .sort!

    _reports.empty? and raise("#{pathname.inspect} does not contain operable reports")
    _reports.one? and raise("only one report identified; redundant")

    $stderr.puts(
      "Operating on #{_reports.length} reports:",
      _reports,
    )

    [@config, _reports]
  end
end
