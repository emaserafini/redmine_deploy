require_dependency 'patches/hide_single_users_from_select/application_helper_patch'

Redmine::Plugin.register :hide_single_users_from_select do
  name 'Hide Single Users From Select Options'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Only allow groups as valid select options'
  version '1.0.0'
  # settings default: { 'empty' => true }, partial: 'settings/hide_users_settings'
end
