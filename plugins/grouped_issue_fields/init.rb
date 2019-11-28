Redmine::Plugin.register :grouped_issue_fields do
  name 'Grouped Issue Fields'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Group issue fields by report type'
  version '1.0.0'
  settings default: { 'empty' => true }, partial: 'settings/grouped_issue_fields_settings'
end

module GroupedIssueFields
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_top, partial: 'issues/grouped_issue_fields'
  end
end
