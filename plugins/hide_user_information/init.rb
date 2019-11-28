Redmine::Plugin.register :hide_user_information do
  name 'Hide User Information'
  author 'Massimo Ercolani'
  author_url 'https://github.com/massierc'
  description "Hide 'My account' section if user is not admin"
  version '1.0.0'
end

module HideUserInformation
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_my_account_contextual, partial: 'my/hide_user_info'
  end
end
