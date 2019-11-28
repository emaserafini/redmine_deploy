class IncidentReport
  attr_reader :workbook, :filename

  def initialize(issue_id, report_type, report_filename)
    @issue = Issue.find(issue_id)
    @report_info = get_report_info(report_type)
    @filename = get_filename(report_filename)
    @plugin_path = Redmine::Plugin.find(:export_incident_report).directory
    @template = RubyXL::Parser.parse("#{@plugin_path}/assets/docs/incident_reports/template_#{@report_info[:type]}.xlsx")
    @values = CellValues.new(@report_info, @issue)
    @workbook = generate_report
  end

  private

  def generate_report
    @values.all_sheets.each_with_index do |sheet, i|
      sheet.each do |k, v|
        next unless valid_field(v)

        ref = RubyXL::Reference.ref2ind(k.to_s)
        cell = @template[i][ref[0]][ref[1]]
        cell.change_contents(v[:value])
      end
    end
    @template.stream
  end

  def valid_field(val)
    val[:condition].to_s == 'true'
  rescue StandardError
    false
  end

  def get_report_info(report_type)
    before_brackets = /.+?(?=\s\()/
    inside_brackets = /(?<=\().+?(?=\))/

    type = report_type[before_brackets]
    stage = report_type[inside_brackets]

    {
      type: type ? underscore(type) : underscore(report_type),
      stage: stage ? underscore(stage) : nil
    }
  end

  def get_filename(filename)
    if filename && !filename.strip.empty?
      underscore(filename) + '.xlsx'
    else
      type = underscore(@report_info[:type])
      stage = @report_info[:stage] ? underscore(@report_info[:stage]) + '_' : ''
      user = underscore(User.current.name)
      Time.now.strftime("#{type}_#{stage}%Y%m%d_%H%M_#{user}") + '.xlsx'
    end
  end

  def underscore(string)
    string.strip.downcase.gsub(/[^0-9A-Za-z_]/, '_')
  end
end
