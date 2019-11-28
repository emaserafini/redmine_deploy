require_dependency 'application_helper'

module HideSingleUsersFromSelect
  module ApplicationHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :principals_options_for_select, :only_groups
      end
    end

    module InstanceMethods
      def principals_options_for_select_with_only_groups(collection, selected = nil)
        default_method = principals_options_for_select_without_only_groups(collection, selected)
        call_origin = caller_locations(1..1).first.path.split('/')[-2]
        # plugin = Redmine::Plugin.find(:hide_single_users_from_select)
        # setting = Setting["plugin_#{plugin.id}"] || plugin.settings[:default]
        # setting = setting.with_indifferent_access[:allow_only_group_selection]

        # return default_method if setting.nil?

        # select_options = case call_origin
        # when 'helpers'
        #   setting[:projects] == "on" ? only_groups_in_options(collection, selected = nil) : default_method
        # when 'issues'
        #   setting[:issues] == "on" ? only_groups_in_options(collection, selected = nil) : default_method
        # when 'issue_categories'
        #   setting[:issue_categories] == "on" ? only_groups_in_options(collection, selected = nil) : default_method
        # else
        #   default_method
        # end
        # select_options

        select_options = if call_origin == 'issues'
                           s = ''
                           groups = ''
                           collection.sort.each do |element|
                             selected_attribute = "selected='selected'" if option_value_selected?(element, selected) ||
                                                                           element.id.to_s == selected ||
                                                                           element.id == @issue.assigned_to_id
                             groups << %(<option value="#{element.id}" #{selected_attribute}>#{h element.name}</option>) if element.is_a? Group
                           end
                           s << %(<optgroup label="#{h(l(:label_group_plural))}">#{groups}</optgroup>) unless groups.empty?
                           s.html_safe
                         else
                           default_method
                         end
        select_options
      end
    end
  end
end

ApplicationHelper.send(:include, HideSingleUsersFromSelect::ApplicationHelperPatch)
