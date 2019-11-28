function setDefaultStatusForMember(memberId) {
  var data = { member_default_status: {} };
  var value = $(`#member_default_status_${memberId}`).val();
  data['member_default_status'][memberId] = value;
  return $.ajax({
    type: 'POST',
    url: `/default_assignee/${memberId}`,
    data: $.param(data)
  });
}
