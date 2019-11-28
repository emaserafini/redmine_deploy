const initSetPriority = () => {
  const execute = () => {
    const fields = {
      impact: getImpactFields(getImpactFieldsNodelist()),
      dataType: getDataTypeField(),
      psd2: getPsd2Fields(),
      priority: document.getElementById('issue_priority_id')
    };

    if (fields.impact) {
      fields.impact.forEach(el =>
        el
          ? el.addEventListener('input', () => {
              setPriority();
              selectRegulations();
            })
          : null
      );
      setPriority();
    }

    if (fields.dataType) {
      fields.dataType.addEventListener('input', selectRegulations);
      selectRegulations();
    }

    if (fields.psd2) {
      fields.psd2.forEach(el =>
        el ? el.addEventListener('input', showPsd2Warning) : null
      );
      showPsd2Warning();
    }

    if (fields.priority) {
      fields.priority.addEventListener('input', showWarningIfMismatch);
    }
  };

  const setPriority = () => {
    const priority = document.getElementById('issue_priority_id');
    const wrongPriorityWarning = document.getElementById(
      'wrong_priority_warning'
    );
    if (selectionIsComplete()) {
      priority.value = calculatePriority(priority);
      wrongPriorityWarning.style.display = 'none';
    }
  };

  const selectRegulations = () => {
    const regulations = getElementValueById('regulations_list');
    const regulationNames = filterRegulations(regulations).map(el => el.name);
    const field = getImpactedRegulationField();

    for (o of field.options) {
      if (regulationNames.includes(o.text.replace(/^\d+\.\s*/, ''))) {
        o.selected = true;
      } else {
        o.selected = false;
      }
    }
  };

  const showPsd2Warning = () => {
    const psd2Info = attachHtmlElementToObj(getElementValueById('psd2_info'));
    isMajorIncident(psd2Info)
      ? toggleMajorIncident(true)
      : toggleMajorIncident(false);
  };

  const calculatePriority = priority => {
    const impact = getSelectedValues();
    const sum = impact.map(getProperty('weight')).reduce(helpers.sum, 0);
    const cumWeight = (sum / impact.length).toFixed();
    const p = (cumWeight * priority.length) / 100;
    return p.toFixed(0);
  };

  const showWarningIfMismatch = e => {
    const wrongPriorityWarning = document.getElementById(
      'wrong_priority_warning'
    );
    if (selectionIsComplete()) {
      if (priorityMismatch(e.target)) {
        wrongPriorityWarning.style.display = null;
      } else {
        wrongPriorityWarning.style.display = 'none';
      }
    }
  };

  const priorityMismatch = priority =>
    priority.value !== calculatePriority(priority);

  const getSelectedDataTypes = () => {
    const dataTypeFieldOptions = getDataTypeField().selectedOptions;
    return [].map.call(dataTypeFieldOptions, option => option.innerHTML);
  };

  const filterRegulations = regulations => {
    const options = {
      impactLevels: getSelectedValues().map(getProperty('impact_level')),
      dataTypes: getSelectedDataTypes()
    };
    return regulations.filter(byImpactLevelAndDataType(options));
  };

  const byImpactLevelAndDataType = ({ impactLevels, dataTypes }) => {
    return regulation => {
      const byImpactLevel = regulation.impact_levels.some(level =>
        impactLevels.includes(level)
      );
      const byDataType = dataTypes.some(type => type.includes(regulation.name));
      return byImpactLevel && byDataType;
    };
  };

  const showTickIfFiltered = ids => {
    return cell => {
      const tick = cell.firstElementChild;
      if (ids.includes(cell.id)) {
        tick.style.display = null;
      } else {
        tick.style.display = 'none';
      }
    };
  };

  const getElementValueById = name => {
    const el = document.getElementById(name);
    return el.value ? JSON.parse(el.value) : null;
  };

  const getImpactFieldsNodelist = () => {
    const fieldList = getImpactValues().map(e => {
      const f = e
        ? document.querySelectorAll(
            `input[name="issue[custom_field_values][${e.id}]"]`
          )
        : null;
      return f ? f : null;
    });
    return fieldList && fieldList[0] ? fieldList : null;
  };

  const getImpactFields = nodeList => {
    return nodeList
      ? nodeList.map(helpers.nodelistToArr).reduce(helpers.concatArrays)
      : null;
  };

  const getDataTypeField = () => {
    const dataTypeFieldId = getElementValueById('data_type_field_id');
    return dataTypeFieldId
      ? document.getElementById(`issue_custom_field_values_${dataTypeFieldId}`)
      : null;
  };

  const getImpactedRegulationField = () => {
    const impactedRegulationFieldId = getElementValueById(
      'impacted_regulation_field_id'
    );
    return impactedRegulationFieldId
      ? document.getElementById(
          `issue_custom_field_values_${impactedRegulationFieldId}`
        )
      : null;
  };

  const getPsd2Fields = () => {
    const fieldList = getElementValueById('psd2_info').map(field => {
      const f = field
        ? document.getElementById(`issue_custom_field_values_${field.id}`)
        : null;
      return f ? f : null;
    });
    return fieldList && fieldList[0] ? fieldList : null;
  };

  const getImpactValues = () => getElementValueById('custom_field_ids');

  const selectionIsComplete = () => !getSelectedValues().some(el => el == null);

  const getSelectedValues = () => {
    return getImpactValues()
      .map(e => {
        const f = e
          ? document.querySelector(
              `input[name="issue[custom_field_values][${e.id}]"]:checked`
            )
          : null;
        return f ? f : null;
      })
      .map(helpers.getValues);
  };

  const getProperty = prop => {
    return (e, i) => {
      const options = getImpactValues()[i].options.find(el => el.id === e);
      return options[prop];
    };
  };

  const attachHtmlElementToObj = element => {
    return element.map(addHtmlElementToProperties);
  };

  const addHtmlElementToProperties = field => {
    const el = document.getElementById(`issue_custom_field_values_${field.id}`);
    field['html'] = el;
    return field;
  };

  const isMajorIncident = psd2Info => {
    const majorImpact = psd2Info
      .map(getImpactArr('major_impact'))
      .reduce(helpers.sum);
    const minorImpact = psd2Info
      .map(getImpactArr('minor_impact'))
      .reduce(helpers.sum);
    return majorImpact > 0 || minorImpact > 2;
  };

  const setMajorIncident = should => {
    const majorIncidentField = document.getElementById(
      `issue_custom_field_values_${getElementValueById(
        'psd2_major_incident_id'
      )}`
    );
    if (!majorIncidentField) return;
    const val = should ? 1 : 0;
    majorIncidentField.value = val;
    disableOtherOptions(majorIncidentField.options, val);
  };

  const disableOtherOptions = (options, current) => {
    [].map.call(options, opt => {
      parseInt(opt.value) === current
        ? (opt.disabled = false)
        : (opt.disabled = true);
    });
  };

  const toggleMajorIncident = status => {
    const psd2Warning = document.getElementById('psd2_warning');
    psd2Warning.style.display = status ? null : 'none';
    setMajorIncident(status);
  };

  const getImpactArr = impact => el => (el[impact] === el.html.value ? 1 : 0);

  const helpers = (() => {
    const nodelistToArr = list => Array.prototype.slice.call(list);
    const concatArrays = (a, b) => a.concat(b);
    const getValues = e => (e ? e.value : e);
    const sum = (a, b) => a + b;

    return {
      nodelistToArr,
      concatArrays,
      getValues,
      sum
    };
  })();

  execute();
};

$(document).ready(initSetPriority);
$(document).ajaxComplete(initSetPriority);
