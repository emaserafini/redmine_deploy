function initHideAssignee() {
  var assigneeField = document.getElementById('issue_assigned_to_id').parentNode;
  assigneeField.style.visibility = 'hidden';
  assigneeField.style.marginTop = '-27px';
}

$(document).ready(initHideAssignee);
$(document).ajaxComplete(initHideAssignee);
