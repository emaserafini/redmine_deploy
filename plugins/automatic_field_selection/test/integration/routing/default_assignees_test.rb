require File.expand_path('../../test_helper', __dir__)

class RoutingDefaultAssigneesTest < Redmine::RoutingTest
  test 'default assignee' do
    should_route 'POST /default_assignee/1' => 'default_assignees#update', member_id: '1'
  end
end
