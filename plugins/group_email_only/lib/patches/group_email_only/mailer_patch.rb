require_dependency 'mailer'

module GroupEmailOnly
  module MailerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :issue_edit, :group_email
      end
    end

    module InstanceMethods
      def issue_edit_with_group_email(journal, to_users, cc_users)
        issue = journal.journalized
        redmine_headers 'Project' => issue.project.identifier,
                        'Issue-Id' => issue.id,
                        'Issue-Author' => issue.author.login
        redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
        message_id journal
        references issue
        @author = journal.user
        s = "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] "
        s << "(#{issue.status.name}) " if journal.new_value_for('status_id')
        s << issue.subject
        @issue = issue
        @users = to_users + cc_users
        @journal = journal
        @journal_details = journal.visible_details(@users.first)
        @issue_url = url_for(controller: 'issues', action: 'show', id: issue, anchor: "change-#{journal.id}")

        plugin = Redmine::Plugin.find(:group_email_only)
        settings = Setting.plugin_group_email_only || plugin.settings[:default]
        settings = settings.with_indifferent_access
        group = settings[:groups][issue.assigned_to_id.to_s]

        if group && !group[:email].blank?
          mail to: group[:email], subject: s
        else
          mail to: to_users, cc: cc_users, subject: s
        end
      end
    end
  end
end

Mailer.send(:include, GroupEmailOnly::MailerPatch)
