const initAutomaticFieldSelection = () => {
  const status = document.getElementById('issue_status_id');

  const setDefaultAssigneeAndCategory = () => {
    const defaultIssueSetting = getElementValueById('default_issue_settings');
    const otherInfo = getElementValueById('dependent_info');
    const data = otherInfo[status.value];
    const fields = getFields(otherInfo);
    const { assignee, category, incManager } = fields;

    if (assignee && category && incManager && data) {
      assignee.value = defaultIssueSetting[status.value];
      category.value = data.category;
      incManager.name.value = data.inc_manager.name.value_id;
      incManager.phone.value = data.inc_manager.phone.value_id;
      incManager.email.value = data.inc_manager.email.value_id;
    }
  };

  const getFields = info => {
    return {
      assignee: document.getElementById('issue_assigned_to_id'),
      category: document.getElementById('issue_category_id'),
      incManager: getIncManagerInfo(info)
    };
  };

  const getElementValueById = name => {
    const el = document.getElementById(name);
    return JSON.parse(el.value);
  };

  const getIncManagerInfo = info => {
    const incManager = info[Object.keys(info)[0]].inc_manager;

    return {
      name: getCustomField(incManager.name.field_id),
      phone: getCustomField(incManager.phone.field_id),
      email: getCustomField(incManager.email.field_id)
    };
  };

  const getCustomField = id =>
    document.getElementById(`issue_custom_field_values_${id}`);

  status.addEventListener('input', setDefaultAssigneeAndCategory);

  setDefaultAssigneeAndCategory();
};

$.ajaxPrefilter(options => (options.async = true));

$(document).ready(initAutomaticFieldSelection);
$(document).ajaxComplete(initAutomaticFieldSelection);
