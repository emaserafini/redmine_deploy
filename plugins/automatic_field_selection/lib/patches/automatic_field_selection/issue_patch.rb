module AutomaticFieldSelection
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def default_change_mgmt_assignees
        case status.name.downcase
        when 'ch 1. new' then find_group_by_name('ch.group.uo approvers')
        when 'ch 2. approved' then find_group_by_name('ch.group.security approvers')
        when 'ch 2. to review u.o' then find_group_by_name('ch.group.initiators')
        when 'ch 3. ready for deploy' then find_group_by_name('ch.group.executor approvers')
        when 'ch 3. to review security' then find_group_by_name('ch.group.uo approvers')
        when 'ch 3. security rejected' then find_group_by_name('ch.group.security approvers')
        when 'ch 4. deploy approved' then find_group_by_name('ch.group.executors')
        when 'ch 4. to review execution' then find_group_by_name('ch.group.uo approvers')
        when 'ch 4. execution rejected' then find_group_by_name('ch.group.executor approvers')
        when 'ch 5. deployed' then find_group_by_name('ch.group.uo approvers')
        when 'ch 5. deploy ko' then find_group_by_name('ch.group.uo approvers')
        when 'ch 10. modification approved' then find_group_by_name('ch.group.initiators')
        when 'ch 10. modified' then find_group_by_name('ch.group.uo approvers')
        else assigned_to
        end
      end

      def find_group_by_name(name)
        project.principals.where('lastname LIKE ?', "%#{name}%").first
      end
    end
  end
end

Issue.send(:include, AutomaticFieldSelection::IssuePatch)
