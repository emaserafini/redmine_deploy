function initAutomaticSelection() {
  var tracker = document.getElementById('issue_tracker_id');
  var assignee = document.getElementById('issue_assigned_to_id');
  var issueStatus = document.getElementById('issue_status_id');
  var group = tracker.options[tracker.selectedIndex].innerText.replace('Pdl.Tracker ', '');
  var user = getElementValueById('current_user')

  tracker.addEventListener('input', init);
  init()

  function init() {
    if (group !== 'Non di competenza') {
      setSelectedOptionByText(assignee, group)
      assignee.parentNode.style.visibility = 'hidden';
      assignee.parentNode.style.marginTop = '-27px';
      if (!user.roles.includes(group)) {
        setSelectedOptionByText(issueStatus, 'Aperto')
      }
    }
  }

  function setSelectedOptionByText(select, text) {
    for (let i = 0; i < select.options.length; i++) {
      if (shouldBeSelected(select.options[i], text)) {
        select.selectedIndex = i;
        break;
      }
    }
  }

  function shouldBeSelected(option, text) {
    return option.text.replace('Pdl', '').includes(text)
  }

  function getElementValueById(name) {
    var el = document.getElementById(name);
    return JSON.parse(el.value);
  };
}

$(document).ready(initAutomaticSelection);
$(document).ajaxComplete(initAutomaticSelection);
