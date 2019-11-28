require_dependency 'patches/export_incident_report/issue_patch'

Redmine::Plugin.register :export_incident_report do
  name 'Export Incident Report'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Add functionality to export PSD2/GDPR report'
  version '1.0.0'
  settings default: { 'empty' => true }
end

module ExportIncidentReport
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, partial: 'issues/export_incident_report'
  end
end
