require_dependency 'patches/group_email_only/mailer_patch'

Redmine::Plugin.register :group_email_only do
  name 'Group Email Only'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description 'Only send single confirmation email for issue creation/edit when group email exists'
  version '1.0.0'
  settings default: { groups: {} }, partial: 'settings/group_emails'
end
