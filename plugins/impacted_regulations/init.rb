require_dependency 'patches/impacted_regulations/issues_helper_patch'

Redmine::Plugin.register :impacted_regulations do
  name 'Impacted Regulations'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Calculates impacted regulations and displays table on issue form'
  version '1.0.0'
end

module ImpactedRegulations
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_issues_form_details_bottom, partial: 'issues/impacted_regulations'
  end
end
