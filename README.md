# 1password_exposed_items

Aggregate multiple [1Password usage reports](https://support.1password.com/reports/#create-a-usage-report-for-a-team-member-or-vault) to identify potentially exposed items.

> You can create usage reports if you’re an owner, administrator, or part of a group with the View Administrative Sidebar permission.

If your business has a 1Password Business plan, there may come a time when your security team wishes to audit a user's activity. This script may assist them with identifying potentially exposed items for rotation.

## Dependencies

- [Ruby](https://www.ruby-lang.org/en/)

The script was developed and tested under Ruby 3.1.2.

## Usage

```
$ ./1password_exposed_items --help
Usage: 1password_exposed_items [options]
        --[no-]csv                   Generate CSV file (default is --csv)
        --[no-]others                Include non-Login items in report (default is --others)
        --[no-]stdout                Send CSV to standard output (default is --no-stdout)
        --in DIRECTORY               Location of reports to process (default is $HOME/Downloads)
```

### Point `1password_exposed_items` at your usage reports

By default it will process all readable CSV files in `$HOME/Downloads` with filenames that match the pattern produced by 1Password CSV export.
```
Example Name User Report YYYY-MM-DD.csv
```

If your reports are located elsewhere, use `--in`.
```
$ ./1password_exposed_items --in ~/some/other/directory
```

### Choose your report destination

By default `1password_exposed_items` will generate a timestamped CSV, `XXXXXXXXXX_1password_exposed_items.csv`. Use `--no-csv` to disable CSV file generation. Use `--stdout` to send the CSV to standard output.
```
$ ./1password_exposed_items --no-csv --stdout > some_other_name.csv
```

### Filter the output

By default it will collect all items types (Login, Document, Secure Note, Password, Credit Card, etc.). Logins are prioitised at the top of the report. It may be infeasible to rotate other item types. Use `--no-others` to omit them from the report.
