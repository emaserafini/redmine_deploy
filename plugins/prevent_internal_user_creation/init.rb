require_dependency 'patches/prevent_internal_user_creation/users_controller_patch'

Redmine::Plugin.register :prevent_internal_user_creation do
  name 'Prevent internal user creation '
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Prevent creation of users with internal auth. Force LDAP user creation.'
  version '1.0.0'
end
