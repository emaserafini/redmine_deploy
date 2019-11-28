require_dependency 'issues_helper'

module AutomaticFieldSelection
  module IssuesHelperPatch
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def serialized_default_issue_settings
        plugin = Redmine::Plugin.find(:automatic_field_selection)
        setting = Setting.find_or_default("plugin_#{plugin.id}")
        setting.value[:member_default_status] ||= {}
        current_values = setting.value[:member_default_status]
        inverted = current_values.invert
        members_to_users = inverted.each_with_object({}) do |(status, member), hash|
          hash[status] = Member.find(member).user_id
        end
        members_to_users.to_json
      end

      def serialized_dependent_info
        it_manager = manager_info('La Vigna')
        security_manager = manager_info('Sommaruga')
        info = {
          IssueStatus.where('name LIKE ?', '%it%').first.id => {
            category: IssueCategory.where('name LIKE ?', '%it%').first.id,
            inc_manager: it_manager
          },
          IssueStatus.where('name LIKE ?', '%security%').first.id => {
            category: IssueCategory.where('name LIKE ?', '%security%').first.id,
            inc_manager: security_manager
          }
        }
        info.to_json
      end

      def manager_info(name)
        {
          name: {
            field_id: custom_field_id('Nome Inc. Manager'),
            value_id: User.find_by_lastname(name) ? User.find_by_lastname(name).id : nil
          },
          phone: {
            field_id: custom_field_id('Telefono Inc. Manager'),
            value_id: custom_field_value_id('Telefono Inc. Manager', name)
          },
          email: {
            field_id: custom_field_id('Email Inc. Manager'),
            value_id: custom_field_value_id('Email Inc. Manager', name.gsub(/[[:space:]]/, ''))
          }
        }
      end

      def custom_field_id(name)
        cf = IssueCustomField.find_by_name(name)
        cf ? cf.id : nil
      end

      def custom_field_value_id(name, value)
        cf = IssueCustomField.find_by_name(name)
        return nil unless cf

        options = cf.possible_values_options
        option = options.find { |arr| arr[0].downcase.include? value.downcase }
        option[1]
      end

      def current_user_pdl_roles
        pdl_roles = User.current.roles.where('roles.name LIKE ?', '%pdl%')
        role_names = pdl_roles.map { |r| r.name.gsub('Pdl.Role ', '') }
        roles = {
          is_supervisor: role_names.include?('Supervisor'),
          roles: role_names
        }
        roles.to_json
      end
    end
  end
end

IssuesHelper.send(:include, AutomaticFieldSelection::IssuesHelperPatch)
