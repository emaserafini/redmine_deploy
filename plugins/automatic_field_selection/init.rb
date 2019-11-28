require_dependency 'issue_status_hook'
require_dependency 'patches/automatic_field_selection/issues_helper_patch'
require_dependency 'patches/automatic_field_selection/issues_controller_patch'
require_dependency 'patches/automatic_field_selection/issue_patch'

Redmine::Plugin.register :automatic_field_selection do
  name 'Default Assignee'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Auto-select assignee, category and inc. manager details on status change'
  version '1.0.0'
  # settings default: { 'empty' => true }
end

module AutomaticFieldSelection
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, partial: 'issues/hide_assignee'
    # render_on :view_issues_form_details_bottom, partial: 'issues/default_assignee'
    # render_on :view_projects_settings_members_table_header, partial: 'projects/settings/members_with_default_assignee_header'
    # render_on :view_projects_settings_members_table_row, partial: 'projects/settings/members_with_default_assignee_row'
  end
end
