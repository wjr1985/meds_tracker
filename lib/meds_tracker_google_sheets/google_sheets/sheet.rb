module GoogleSheets
  class Sheet
    APPLICATION_NAME = "Meds Tracker".freeze
    DATE_RANGE = "A1:A".freeze

    attr_reader :service, :sheet_id

    def initialize(sheet_id:)
      @service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = GoogleSheets::Authorization.credentials

      @sheet_id = sheet_id
    end

    def add_taken
      row = find_or_create_row_for_date
      add_time(row, :taken)
    end

    def add_start
      row = find_or_create_row_for_date
      add_time(row, :start)
    end

    def add_end
      row = find_or_create_row_for_date
      add_time(row, :end)
    end

    private

    def find_or_create_row_for_date
      date_values = get_values(DATE_RANGE)

      current_time = Time.current
      current_date = current_time.strftime("%F")

      # nil if not found
      index = date_values.find_index { |dv| dv.first == current_time.strftime("%F") }
      if index.nil?
        previous_index = date_values.find_index { |dv| dv.first == (current_time - 1.day).strftime("%F") } || -1
        index = add_date(previous_index, current_date)
      end

      index + 1
    end

    def get_values(range)
      service.get_spreadsheet_values(sheet_id, range).values
    end

    def add_date(previous_index, date)
      range = "A#{previous_index + 2}"
      result = add_value_to_sheet(range, date)
      raise "Updated too many or not enough cells: #{result.updated_cells}" if result.updated_cells != 1

      previous_index + 1
    end

    def add_time(row, type)
      current_time = Time.current.strftime("%r")

      case type
      when :taken
        add_value_to_sheet("B#{row}", current_time)
      when :start
        add_value_to_sheet("C#{row}", current_time)
      when :end
        add_value_to_sheet("D#{row}", current_time)
        add_value_to_sheet("E#{row}", "=D#{row}-C#{row}")
      else
        raise "Invalid type: #{type}"
      end
    end

    def add_value_to_sheet(range, value)
      values = [[value]]
      value_range_object = Google::Apis::SheetsV4::ValueRange.new(range: range, values: values)
      service.update_spreadsheet_value(sheet_id, range, value_range_object, value_input_option: "USER_ENTERED")
    end
  end
end
