require File.expand_path('../test_helper', __dir__)

class ProjectsControllerTest < Redmine::ControllerTest
  fixtures :members, :users, :projects

  def setup
    @admin = User.find_by_admin(true)
    @request.session[:user_id] = @admin.id
    @project = @admin.projects.first
  end

  test 'project members settings associated status dropdown should be visible for groups' do
    get 'settings', id: @project.id, tab: :members
    group_member = @project.memberships.find { |m| m.principal.is_a? Group }
    assert_response :success
    assert_select "select#member_default_status_#{group_member.id}"
  end

  test 'project members settings associated status dropdown should not be visible for single users' do
    get 'settings', id: @project.id, tab: :members
    single_member = @project.memberships.find { |m| m.principal.is_a? User }
    assert_response :success
    assert_select "select#member_default_status_#{single_member.id}", false
  end
end
