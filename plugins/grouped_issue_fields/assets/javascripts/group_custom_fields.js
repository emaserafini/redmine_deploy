function initGroupCustomFields(ajax = false) {
  return function() {
    var issueFormat = document.getElementById('issue_format_selector');
    var hiddenField = document.getElementById('grouped_fields_ids');
    var groupedFieldsIds = JSON.parse(hiddenField.value);
    var reportTypes = ['PSD2', 'GDPR', 'PCI'];

    if (ajax) {
      toggleFieldsToShow();
    }

    issueFormat.addEventListener('input', toggleFieldsToShow);

    function toggleFieldsToShow() {
      if (!reportTypes.includes(issueFormat.value)) {
        allFields().forEach(show);
      } else {
        fieldsToShow().forEach(show);
        fieldsToHide().forEach(hide);
      }
    }

    function allFields() {
      var arrayOfIds = flatten(Object.values(groupedFieldsIds));
      return toArrayOfElements(arrayOfIds);
    }

    function fieldsToShow() {
      var arrayOfIds = groupedFieldsIds[issueFormat.value];
      return toArrayOfElements(arrayOfIds);
    }

    function fieldsToHide() {
      var fields = Object.assign({}, groupedFieldsIds);
      delete fields[issueFormat.value];
      var arrayOfIds = flatten(Object.values(fields));
      return toArrayOfElements(arrayOfIds);
    }

    function idToElement(id) {
      return document.getElementById(`issue_custom_field_values_${id}`);
    }

    function toArrayOfElements(arrayOfIds) {
      return arrayOfIds ? arrayOfIds.map(idToElement) : [];
    }

    function show(field) {
      field.parentNode.style.display = null;
    }

    function hide(field) {
      field.parentNode.style.display = 'none';
    }

    function flatten(arrOfArr) {
      return [].concat.apply([], arrOfArr);
    }
  };
}

$.ajaxPrefilter(function(options) {
  options.async = true;
});

$(document).ready(initGroupCustomFields());
$(document).ajaxComplete(initGroupCustomFields(true));
