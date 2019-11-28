class DefaultAssigneesController < ApplicationController
  def update
    member_id = params[:member_id]
    status_id = params[:member_default_status][member_id]
    @member = Member.find(member_id)
    @status = IssueStatus.find(status_id) unless status_id.to_s.empty?
    update_setting
    redirect_to :back
  end

  private

  def update_setting
    plugin = Redmine::Plugin.find(:automatic_field_selection)
    setting = Setting.find_or_default("plugin_#{plugin.id}")
    setting.value[:member_default_status] ||= {}
    current_values = setting.value[:member_default_status]
    new_value = @status ? { @member.id => @status.id } : { @member.id => nil }
    new_setting = current_values ? current_values.merge(new_value) : new_value
    setting.value = { member_default_status: new_setting }
    setting.save
  end
end
