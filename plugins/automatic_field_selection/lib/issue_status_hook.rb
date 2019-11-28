class IssueStatusHook < Redmine::Hook::ViewListener
  def controller_issues_new_before_save(context = {})
    set_default_assignee(context[:issue])
    set_default_due_date(context[:issue])
  end

  def controller_issues_bulk_edit_before_save(context = {})
    set_default_assignee(context[:issue])
  end

  private

  # def set_default_assignee(issue)
  #   plugin = Redmine::Plugin.find(:automatic_field_selection)
  #   setting = Setting["plugin_#{plugin.id}"] || plugin.settings[:default]
  #   setting[:member_default_status] = {} unless setting[:member_default_status]
  #   inverted = setting[:member_default_status].invert
  #   default_assignees = inverted.each_with_object({}) do |(status, member), hash|
  #     hash[status] = Member.find(member).user_id
  #   end
  #   assignee_id = default_assignees[issue.status_id.to_s]
  #   issue.assigned_to_id = assignee_id
  # end

  def set_default_assignee(issue)
    return unless issue.tracker.name.downcase.starts_with? 'ch'

    issue.assigned_to = issue.default_change_mgmt_assignees
  end

  def set_default_due_date(issue)
    issue.due_date ||= issue.start_date + 1.day
  end
end
