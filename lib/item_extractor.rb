require "csv"
require "set"

class ItemExtractor
  EXPECTED_REPORT_HEADERS = [
    :item_uuid,
    :item_name,
    :vault_uuid,
    :vault_name,
    :item_type,
    :used_at,
    :action,
  ]

  ITEM_HEADERS = [
    :item_type,
    :vault_uuid,
    :vault_name,
    :item_uuid,
    :item_name,
  ]

  Item = Struct.new(*ITEM_HEADERS) do
    def login?
      item_type == "Login"
    end
  end

  def self.call(...)
    new(...).items
  end

  # @param config [Configuration]
  # @param reports [Array<Pathname>]
  def initialize(config, reports)
    @config = config
    @reports = reports
  end

  # @return [Array<(Configuration, Array<ItemExtractor::Item>)>]
  def items
    count_rows = 0
    _items = Set.new

    @reports.each do |report|
      table = CSV.table(report)

      unless table.headers == EXPECTED_REPORT_HEADERS
        $stderr.puts("Skipping #{report.basename}: headers mismatch")
        next
      end

      $stderr.puts("Processing #{report.basename} ...")

      table.each do |row|
        _items << Item.new(*row.fields(*ITEM_HEADERS))
        count_rows += 1
      end
    end

    count_logins = _items.count(&:login?)
    count_others = _items.size - count_logins
    $stderr.puts(
      "Processed #{count_rows} total rows",
      "Extracted #{count_logins} unique Login items",
      "Extracted #{count_others} unique non-Login items",
    )
    (count_logins.positive? || (@config.others? && count_others.positive?)) or
      raise("given configuration, no items to report on")

    [
      @config,
      _items.sort_by { |item| item.values_at(1, 0, 3) },
    ]
  end
end
