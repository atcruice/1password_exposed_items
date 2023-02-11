require "csv"
require "item_extractor"

class OutputGenerator
  def self.call(...)
    new(...).generate
  end

  # @param config [Configuration]
  # @param items [Array<ItemExtractor::Item>]
  def initialize(config, items)
    @config = config
    @items = items
    @outputs = outputs
  end

  # @return [void]
  def generate
    rows.each do |row|
      @outputs.each { |csv| csv << row }
    end
  end

  private

  def rows
    logins, others = @items.partition(&:login?)
    _rows = logins
    _rows.concat(others) if @config.others?
    _rows.map!(&:to_a)
  end

  def outputs
    _outputs = []
    _outputs.push($stdout) if @config.stdout?

    if @config.csv?
      file = File.open("#{Time.now.to_i}_1password_exposed_items.csv", "w")
      at_exit { file.close }
      _outputs.push(file)
      $stderr.puts("Generating #{file.path} ...")
    end

    _outputs.map! do |io|
      CSV.new(
        io,
        headers: ItemExtractor::ITEM_HEADERS,
        write_headers: true,
      )
    end
  end
end
