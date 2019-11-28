require_dependency 'issues_controller'

module AutomaticFieldSelection
  module IssuesControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :edit, :automatic_field_selection
      end
    end

    module InstanceMethods
      def edit_with_automatic_field_selection
        return unless update_issue_from_params

        if @issue.tracker.name.downcase.starts_with? 'inc'
          update_issue_with_automatic_fields if issue_assigned
          update_issue_with_managers if issue_solved
        elsif @issue.tracker.name.downcase.starts_with? 'ch'
          update_issue_with_change_mgmt_status
        end

        respond_to do |format|
          format.html {}
          format.js
        end
      end

      private

      def issue_assigned
        issue_status = @issue.status.name.downcase
        ['allocato it', 'allocato security'].any? { |type| issue_status.include? type }
      end

      def issue_solved
        issue_status = @issue.status.name.downcase
        issue_status.include?('risolto') && @issue.category
      end

      def update_issue_with_automatic_fields
        issue_status = @issue.status.name.downcase
        managers = { it: 'La Vigna', security: 'Sommaruga' }
        dept = issue_status.include?('allocato it') ? 'it' : 'security'
        @issue.category = IssueCategory.where('name LIKE (?) AND project_id = (?)', "%#{dept}%", @issue.project_id).first
        @issue.custom_field_values = get_custom_field_values(managers[dept.to_sym])
        @issue.assigned_to = @issue.find_group_by_name("inc.group.managers #{dept}")
      end

      def update_issue_with_managers
        dept = @issue.category.name.downcase.gsub(/\A\d+. /, '')
        @issue.assigned_to = @issue.find_group_by_name("inc.group.managers #{dept}")
      end

      def update_issue_with_change_mgmt_status
        @issue.assigned_to = @issue.default_change_mgmt_assignees
      end

      def get_custom_field_values(name)
        arr = @issue.custom_field_values.map do |cf|
          case cf.custom_field.name
          when 'Nome Inc. Manager'
            [
              cf.custom_field_id,
              get_updated_custom_field_value(cf, name, 'user')
            ]
          when 'Telefono Inc. Manager'
            [
              cf.custom_field_id,
              get_updated_custom_field_value(cf, name, 'enum')
            ]
          when 'Email Inc. Manager'
            [
              cf.custom_field_id,
              get_updated_custom_field_value(cf, name.gsub(/[[:space:]]/, ''), 'enum')
            ]
          else
            [
              cf.custom_field_id,
              cf.value
            ]
          end
        end
        Hash[arr]
      end

      def get_updated_custom_field_value(cfield, name, mode = 'user')
        name = name.downcase
        if mode == 'user'
          User.find_by_lastname(name) ? User.find_by_lastname(name).id : nil
        else
          opt = cfield.custom_field.possible_values_options.find { |o| o[0].downcase.include? name }
          opt ? opt[1] : nil
        end
      end

      # def default_assignees
      #   plugin = Redmine::Plugin.find(:automatic_field_selection)
      #   setting = Setting["plugin_#{plugin.id}"] || plugin.settings[:default]
      #   setting[:member_default_status] = {} unless setting[:member_default_status]
      #   inverted = setting[:member_default_status].invert
      #   members_to_users = inverted.each_with_object({}) do |(status, member), hash|
      #     hash[status] = Member.find(member).user_id
      #   end
      #   members_to_users
      # end
    end
  end
end

IssuesController.send(:include, AutomaticFieldSelection::IssuesControllerPatch)
