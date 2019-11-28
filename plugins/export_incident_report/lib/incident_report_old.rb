# class IncidentReportOld
#   attr_reader :workbook, :filename

#   def initialize(issue_id, report_type, report_filename)
#     @issue = Issue.find(issue_id)
#     @report_type = report_type
#     @filename = get_filename(report_filename)
#     @plugin_path = Redmine::Plugin.find(:export_incident_report).directory
#     @template = RubyXL::Parser.parse("#{@plugin_path}/assets/docs/incident_reports/template.xlsx")
#     @headers = @template[0][0]
#     @type_col_index = get_col_index('TYPE')
#     @methods_col_index = get_col_index('METHODS')
#     @values_col_index = get_col_index('VALUES')
#     @workbook = generate_report
#   end

#   private

#   def generate_report
#     @template.each do |sheet|
#       sheet.each do |row|
#         next unless row_is_valid(row)

#         fill(row)
#       end
#       clear_helper_fields(sheet)
#     end
#     @template.write(File.join(@plugin_path, 'assets', 'docs', 'incident_reports', 'archive', @filename))
#   end

#   def fill(row)
#     if row[@methods_col_index].value.starts_with? 'report_type'
#       set_report_type(row)
#     else
#       set_cell_value(row)
#     end
#   end

#   def get_col_index(col_header)
#     @headers.cells.find { |cell| cell && cell.value == col_header }.index_in_collection
#   end

#   def row_is_valid(row)
#     row \
#     && row.index_in_collection != 0 \
#     && row[@methods_col_index] \
#     && %w[empty report_type].exclude?(row[@methods_col_index].value)
#   end

#   def set_cell_value(row)
#     row[@values_col_index].change_contents(get_cell_value(row[@methods_col_index].value))
#   end

#   def set_report_type(row)
#     current_row_report_type = row[@methods_col_index].value.gsub(/\Areport_type:/i, '').to_i
#     row[@type_col_index].change_contents('X') if @report_type == current_row_report_type
#   end

#   def get_cell_value(val)
#     case val
#     when its_a_function then eval(val)
#     when its_fixed then get_fixed_value(val)
#     when its_todo then 'TODO'
#     else '<ERROR>'
#     end
#   end

#   def its_a_function
#     ->(val) { val.starts_with?('"') }
#   end

#   def its_fixed
#     ->(val) { val.downcase.starts_with?('fixed') }
#   end

#   def its_todo
#     ->(val) { val.downcase.starts_with?('todo') }
#   end

#   def get_fixed_value(string)
#     string.gsub(/\Afixed:/i, '')
#   end

#   def clear_helper_fields(worksheet)
#     worksheet.delete_row(0)
#     worksheet.delete_column(@methods_col_index)
#   end

#   def get_filename(filename)
#     if !filename.strip.empty?
#       filename.strip.downcase.gsub(/[^0-9A-Za-z_]/, '') + '.xlsx'
#     else
#       Time.now.strftime("PSD2_%Y%m%d_%H%M_#{User.current.name}") + '.xlsx'
#     end
#   end
# end
