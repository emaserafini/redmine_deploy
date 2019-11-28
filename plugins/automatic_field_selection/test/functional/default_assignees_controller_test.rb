require File.expand_path('../test_helper', __dir__)

class DefaultAssigneesControllerTest < Redmine::ControllerTest
  fixtures :members, :users, :projects

  def setup
    @admin = User.find_by_admin(true)
    @request.session[:user_id] = @admin.id
    @project = @admin.projects.first
    @member = @project.memberships.find { |m| m.principal.is_a? Group }
  end

  test 'update' do
    request.env['HTTP_REFERER'] = "http://localhost:3000/projects/#{@project.id}/settings/members"
    params = { member_id: @member.id, member_default_status: { member_id: @member.id } }
    post :update,
         controller: :default_assignees,
         params: params
    assert_response :found
  end
end
