class CellValues
  def initialize(report_info, issue)
    @report_info = report_info
    set_values(issue)
  end

  def all_sheets
    case @report_info[:stage]
    when 'initial' then [send("sheet1_#{@report_info[:type]}")]
    when 'intermediate' then [send("sheet1_#{@report_info[:type]}"), sheet2]
    when 'final' then [send("sheet1_#{@report_info[:type]}"), sheet2]
    else [send(@report_info[:type])]
    end
  end

  private

  def set_values(issue)
    @id = issue.id
    @subject = issue.subject
    @author = "#{issue.author.firstname} #{issue.author.lastname}"
    @author_email = issue.author.mail
    @priority = issue.priority.name
    @status = issue.status.name
    @status_id = @status.match(/^(Inc\s)(\d+)(.*)/)[2].to_i
    @duration = issue.estimated_hours
    @issue_creation_date = issue.created_on.strftime('%d/%m/%Y')
    @issue_creation_time = issue.created_on.strftime('%H:%M')
    @incident_id = issue.start_date.strftime("%Y%m%d_#{issue.id}")
    @company = issue.get_custom_field_value('società')
    @address = issue.get_custom_field_value('dove')
    @start_date = issue.start_date.strftime('%d/%m/%Y')
    @time_of_incident = issue.get_custom_field_value('orario evento')
    @manager = issue.get_custom_field_value('nome inc. manager')
    @manager_role = get_manager_role
    @manager_email = issue.get_custom_field_value('email inc. manager')
    @manager_phone = issue.get_custom_field_value('telefono inc. manager')
    @description = issue.description
    @identified_problem = issue.get_custom_field_value('problema identificato')
    @impacted_data_types = issue.get_custom_field_value('tipo di dati impattati')
    @breach_types = issue.get_custom_field_value('tipo di breach')
    @breach_origin = issue.get_custom_field_value('natura origine breach')
    @impacted_structure = issue.get_custom_field_value('struttura impattata')
    @impacted_people = issue.get_custom_field_value('gdpr persone impattate')
    @impacted_regulation = issue.get_custom_field_value('normativa impattata')
    @system_performance = issue.get_custom_field_value('performance sistemi')
    @informed_authorities = issue.get_custom_field_value('autorità informate')
    @technical_solution = issue.get_custom_field_value('soluzione tecnica')
    @organizational_solution = issue.get_custom_field_value('soluzione organizzativa')
    @analysis = issue.get_custom_field_value('analisi / analisi forense')
    @business_continuity_observations = issue.get_custom_field_value('nota bc/dr')
    @incident_management_observations = issue.get_custom_field_value('nota gestione incidente')
    @psd2_status = issue.get_custom_field_value('PSD2 Status')
    @psd2_general_impact = issue.get_custom_field_value('PSD2 Impatto generale')
    @psd2_transactions = issue.get_custom_field_value('PSD2 Transazioni interessate')
    @psd2_users = issue.get_custom_field_value('PSD2 Utenti interessati')
    @psd2_downtime = issue.get_custom_field_value('PSD2 Periodo indisp. servizio')
    @psd2_impacted_systems = issue.get_custom_field_value('PSD2 Sistemi interessati')
    @psd2_economic_impact = issue.get_custom_field_value('PSD2 Impatto economico')
    @psd2_escalation = issue.get_custom_field_value('PSD2 Alta escalation interna')
    @psd2_other_psps = issue.get_custom_field_value('PSD2 Altri PSP interessati')
    @psd2_reputational_impact = issue.get_custom_field_value('PSD2 Impatto sulla reputazione')
    @psd2_channels = issue.get_custom_field_value('PSD2 Canali Interessati')
    @gdpr_data_owners_informed = issue.get_custom_field_value('GDPR Titolari dati informati')
  end

  def get_manager_role
    if @manager.downcase.start_with? 'sommaruga'
      'CISO'
    elsif @manager.downcase.start_with? 'la vigna'
      'Head of Infrastructure'
    end
  end

  def sheet1_psd2
    {
      C11: {
        desc: 'Data del rapporto',
        condition: true,
        value: @start_date.to_s
      },
      G11: {
        desc: 'Ora',
        condition: true,
        value: @time_of_incident.to_s
      },
      C12: {
        desc: 'Numero di identificazione dell’incidente, se applicabile (per il rapporto intermedio e finale)',
        condition: true,
        value: @incident_id.to_s
      },
      C18: {
        desc: 'Tipo di rapporto',
        condition: true,
        value: 'X'
      },
      C20: {
        desc: 'Nome PSP',
        condition: true,
        value: 'Mercury Payment Services SpA'
      },
      C21: {
        desc: 'Numero di identificazione del PSP, se pertinente',
        condition: true,
        value: 'TODO'
      },
      C22: {
        desc: 'Numero di autorizzazione del PSP',
        condition: true,
        value: 'TODO'
      },
      C23: {
        desc: 'Capogruppo, se applicabile',
        condition: true,
        value: 'Mercury Payment Services SpA'
      },
      C24: {
        desc: 'Paese di origine',
        condition: true,
        value: 'Italia'
      },
      C25: {
        desc: 'Paese/paesi interessato/i dall’incidente',
        condition: true,
        value: 'Italia'
      },
      C26: {
        desc: 'Referente principale da contattare',
        condition: true,
        value: 'Fernando Ceschel (RISK)'
      },
      G26: {
        desc: 'E-mail',
        condition: true,
        value: 'ferdinando.ceschel@mercurypayments.it'
      },
      I26: {
        desc: 'Telefono',
        condition: true,
        value: '+39 366 6100287'
      },
      C27: {
        desc: 'Referente secondario da contattare',
        condition: true,
        value: 'Lorenzo Sommaruga (CISO) - Daniele La Vigna (IT Manager)'
      },
      G27: {
        desc: 'E-mail',
        condition: true,
        value: 'lorenzo.sommaruga@mercurypayments.it'
      },
      I27: {
        desc: 'Telefono',
        condition: true,
        value: '+39 348 5383497'
      },
      C29: {
        desc: 'Nome dell’entità segnalante',
        condition: true,
        value: 'N/A'
      },
      C30: {
        desc: 'Numero di identificazione, se pertinente',
        condition: true,
        value: 'N/A'
      },
      C31: {
        desc: 'Numero di autorizzazione, se applicabile',
        condition: true,
        value: 'N/A'
      },
      C32: {
        desc: 'Referente da contattare',
        condition: true,
        value: 'N/A'
      },
      C33: {
        desc: 'Referente secondario da contattare',
        condition: true,
        value: 'N/A'
      },
      C35: {
        desc: 'Data e ora di rilevazione dell’incidente',
        condition: true,
        value: "#{@start_date} - #{@time_of_incident}"
      },
      C37: {
        desc: 'Fornire una breve descrizione generale dell’incidente',
        condition: true,
        value: @description.to_s
      }
    }
  end

  def sheet1_pci
    {
      C11: {
        desc: 'Data del rapporto',
        condition: true,
        value: @start_date.to_s
      },
      G11: {
        desc: 'Ora',
        condition: true,
        value: @time_of_incident.to_s
      },
      C12: {
        desc: 'Numero di identificazione dell’incidente, se applicabile (per il rapporto intermedio e finale)',
        condition: true,
        value: @incident_id.to_s
      },
      C17: {
        desc: 'Azienda',
        condition: true,
        value: 'Mercury Payments SpA'
      },
      C18: {
        desc: 'Indirizzo / CAP /  Paese',
        condition: true,
        value: 'Viale Giulio Richard, 7 - 20145 ITALIA'
      },
      C19: {
        desc: 'Comune / Porvincia',
        condition: true,
        value: 'Milano (MI)'
      },
      C20: {
        desc: 'Incidente Manager / Contatto',
        condition: true,
        value: 'Lorenzo Sommaruga / Daniele La Vigna'
      },
      C21: {
        desc: 'Funzione in Azienda',
        condition: true,
        value: 'CISO / IT Manager'
      },
      C22: {
        desc: 'Pec / Email',
        condition: true,
        value: 'lorenzo.sommaruga@mercurypayments.it'
      },
      C23: {
        desc: 'Telefono / Cellulare',
        condition: true,
        value: '+39 348 5383497'
      },
      C25: {
        desc: "Livello di criticità dell'incidente",
        condition: true,
        value: @priority.to_s
      },
      C26: {
        desc: 'Quando si è verificato incidente',
        condition: true,
        value: @start_date.to_s
      },
      C27: {
        desc: 'Denominazione degli applicativi e relativi db impattati da incidente',
        condition: true,
        value: 'TBD'
      },
      C28: {
        desc: 'Modalità di esposizione al rischio',
        condition: true,
        value: @breach_types.to_s
      },
      C29: {
        desc: 'Comportamento e ubicazione dei sistemi impattati',
        condition: true,
        value: "ubicazione: #{@impacted_structure}; comportamento: #{@system_performance}"
      },
      C30: {
        desc: "Dove e come è avvenuto l'incidente",
        condition: true,
        value: "Incidente avvenuto presso #{@company}. Descrizione: #{@description}"
      },
      C31: {
        desc: "Come si è venuto a conoscenza dell'incidente?",
        condition: true,
        value: "L'incidente è stato segnalato da #{@author} (#{@author_email})"
      },
      C32: {
        desc: 'Quante persone sono potenzialmente impattate da data breach',
        condition: true,
        value: @impacted_people.to_s
      },
      C33: {
        desc: 'Categoria di dati impattati da incidente',
        condition: true,
        value: @impacted_data_types.to_s
      },
      C35: {
        desc: "Le persone, clienti impattati dall'incidente sono stati avvertiti ?",
        condition: true,
        value: "Autorità informate: #{@informed_authorities}"
      },
      C37: {
        desc: 'Issuing:',
        condition: true,
        value: ''
      },
      C38: {
        desc: 'Acquiring pos fisico:',
        condition: true,
        value: ''
      },
      C39: {
        desc: 'Acquiring pos virtuale:',
        condition: true,
        value: ''
      },
      C40: {
        desc: 'Acquiring pos mobile:',
        condition: true,
        value: ''
      },
      C41: {
        desc: 'Acquiring ATM:',
        condition: true,
        value: ''
      },
      C42: {
        desc: 'Description (details)',
        condition: true,
        value: ''
      },
      C44: {
        desc: 'Causa probabile',
        condition: true,
        value: @identified_problem.to_s
      },
      C45: {
        desc: 'Incident owner presso Mercury',
        condition: true,
        value: @impacted_structure.to_s
      },
      C46: {
        desc: 'Altre Struttura Mercury coinvolte',
        condition: true,
        value: 'IT Infrastructure'
      },
      C47: {
        desc: 'Remediation(s) (including workarounds)',
        condition: true,
        value: "Soluzione tecnica: #{@technical_solution}. Soluzione organizzativa: #{@organizational_solution}."
      },
      C53: {
        desc: 'Tipo di rapporto',
        condition: true,
        value: 'X'
      },
      C55: {
        desc: 'Nome PSP',
        condition: true,
        value: 'Mercury Payment Services SpA'
      },
      C56: {
        desc: 'Numero di identificazione del PSP, se pertinente',
        condition: true,
        value: 'TODO'
      },
      C57: {
        desc: 'Numero di autorizzazione del PSP',
        condition: true,
        value: 'TODO'
      },
      C58: {
        desc: 'Capogruppo, se applicabile',
        condition: true,
        value: 'Mercury Payment Services SpA'
      },
      C59: {
        desc: 'Paese di origine',
        condition: true,
        value: 'Italia'
      },
      C60: {
        desc: 'Paese/paesi interessato/i dall’incidente',
        condition: true,
        value: 'Italia'
      },
      C61: {
        desc: 'Referente principale da contattare',
        condition: true,
        value: 'Fernando Ceschel (RISK)'
      },
      G61: {
        desc: 'E-mail',
        condition: true,
        value: 'ferdinando.ceschel@mercurypayments.it'
      },
      I61: {
        desc: 'Telefono',
        condition: true,
        value: '+39 366 6100287'
      },
      C62: {
        desc: 'Referente secondario da contattare',
        condition: true,
        value: 'Lorenzo Sommaruga (CISO) - Daniele La Vigna (IT Manager)'
      },
      G62: {
        desc: 'E-mail',
        condition: true,
        value: 'lorenzo.sommaruga@mercurypayments.it'
      },
      I62: {
        desc: 'Telefono',
        condition: true,
        value: '+39 348 5383497'
      },
      C64: {
        desc: 'Nome dell’entità segnalante',
        condition: true,
        value: 'N/A'
      },
      C65: {
        desc: 'Numero di identificazione, se pertinente',
        condition: true,
        value: 'N/A'
      },
      C66: {
        desc: 'Numero di autorizzazione, se applicabile',
        condition: true,
        value: 'N/A'
      },
      C67: {
        desc: 'Referente da contattare',
        condition: true,
        value: 'N/A'
      },
      C68: {
        desc: 'Referente secondario da contattare',
        condition: true,
        value: 'N/A'
      },
      C70: {
        desc: 'Data e ora di rilevazione dell’incidente',
        condition: true,
        value: "#{@start_date} - #{@time_of_incident}"
      },
      C72: {
        desc: 'Fornire una breve descrizione generale dell’incidente',
        condition: true,
        value: @description.to_s
      }
    }
  end

  def sheet2
    {
      C4: {
        desc: "Fornire una descrizione più DETTAGLIATA dell'incidente",
        condition: true,
        value: "#{@description}; #{@identified_problem} "
      },
      C5: {
        desc: 'Data e ora di inizio dell’incidente (se già nota)',
        condition: true,
        value: "#{@start_date} - #{@time_of_incident}"
      },
      C6: {
        desc: 'Status dell’incidente',
        condition: (@psd2_status.start_with? 'Diagnosi').to_s,
        value: 'X'
      },
      C7: {
        desc: 'Status dell’incidente',
        condition: (@psd2_status.start_with? 'Riparazione').to_s,
        value: 'X'
      },
      E6: {
        desc: 'Status dell’incidente',
        condition: (@psd2_status.start_with? 'Recupero').to_s,
        value: 'X'
      },
      E7: {
        desc: 'Status dell’incidente',
        condition: (@psd2_status.start_with? 'Ripristino').to_s,
        value: 'X'
      },
      C10: {
        desc: 'Impatto generale',
        condition: (@psd2_general_impact.start_with? 'Integrità').to_s,
        value: 'X'
      },
      C11: {
        desc: 'Impatto generale',
        condition: (@psd2_general_impact.start_with? 'Disponibilità').to_s,
        value: 'X'
      },
      E10: {
        desc: 'Impatto generale',
        condition: (@psd2_general_impact.start_with? 'Riservatezza').to_s,
        value: 'X'
      },
      E11: {
        desc: 'Impatto generale',
        condition: (@psd2_general_impact.start_with? 'Autenticità').to_s,
        value: 'X'
      },
      G10: {
        desc: 'Impatto generale',
        condition: (@psd2_general_impact.start_with? 'Continuità').to_s,
        value: 'X'
      },
      M10: {
        desc: 'Impatto generale',
        condition: true,
        value: 'TODO'
      },
      D12: {
        desc: 'Transazioni interessate',
        condition: true,
        value: @psd2_transactions.to_s
      },
      D17: {
        desc: 'Utenti di servizi di pagamento interessati',
        condition: true,
        value: @psd2_users.to_s
      },
      D20: {
        desc: 'Periodo di indisponibilità del servizio',
        condition: true,
        value: @psd2_downtime.to_s
      },
      D22: {
        desc: 'Impatto economico',
        condition: true,
        value: @psd2_economic_impact.to_s
      },
      C25: {
        desc: 'Alto livello di escalation interna',
        condition: (@psd2_escalation == 'Sì').to_s,
        value: 'X'
      },
      E25: {
        desc: 'Alto livello di escalation interna',
        condition: (@psd2_escalation.start_with? 'Sì, e probabile attivazione modalità di crisi (o equiv)').to_s,
        value: 'X'
      },
      G25: {
        desc: 'Alto livello di escalation interna',
        condition: (@psd2_escalation.start_with? 'No').to_s,
        value: 'X'
      },
      C27: {
        desc: 'Altri PSP o infrastrutture rilevanti potenzialmente interessati',
        condition: @psd2_other_psps.to_s,
        value: 'X'
      },
      E27: {
        desc: 'Altri PSP o infrastrutture rilevanti potenzialmente interessati',
        condition: @psd2_other_psps.to_s,
        value: 'X'
      },
      C29: {
        desc: 'Impatto sulla reputazione',
        condition: @psd2_reputational_impact.to_s,
        value: 'X'
      },
      C44: {
        desc: 'Edificio/i interessato/i (indirizzo), se applicabile',
        condition: true,
        value: @address.to_s
      },
      C46: {
        desc: 'Canali commerciali interessati',
        condition: (@psd2_channels.start_with? 'E-banking').to_s,
        value: 'X'
      },
      E46: {
        desc: 'Canali commerciali interessati',
        condition: (@psd2_channels.start_with? 'Mobile banking').to_s,
        value: 'X'
      },
      G45: {
        desc: 'Canali commerciali interessati',
        condition: (@psd2_channels.start_with? 'Punto vendita').to_s,
        value: 'X'
      },
      E47: {
        desc: 'Canali commerciali interessati',
        condition: (@psd2_channels.start_with? 'Sportelli automatici (ATM)').to_s,
        value: 'X'
      }
    }
  end

  def gdpr
    {
      B4: {
        desc: 'Azienda titolare del Trattamento',
        condition: true,
        value: @company.to_s
      },
      B6: {
        desc: 'Comune / Provincia',
        condition: true,
        value: 'Milano'
      },
      B8: {
        desc: 'Indirizzo / CAP /  Paese',
        condition: true,
        value: @address.to_s
      },
      B10: {
        desc: 'Incidente Manager / Contatto',
        condition: true,
        value: @manager.to_s
      },
      B12: {
        desc: 'Funzione in Azienda',
        condition: true,
        value: 'IT Incident Manager'
      },
      B14: {
        desc: 'Pec / Email',
        condition: true,
        value: @manager_email.to_s
      },
      B16: {
        desc: 'Telefono / Cellulare',
        condition: true,
        value: @manager_phone.to_s
      },
      B18: {
        desc: 'Denominazione della/e banca/banche dati e/o relativi applicativi oggetto di data breach',
        condition: true,
        value: 'TBD'
      },
      B20: {
        desc: 'Quando si è verificata la violazione dei dati',
        condition: true,
        value: 'X'
      },
      C20: {
        desc: 'Quando si è verificata la violazione dei dati',
        condition: true,
        value: "il giorno #{@start_date} alle ore #{@time_of_incident}"
      },
      B23: {
        desc: 'Quando si è verificata la violazione dei dati',
        condition: (!@status.downcase.start_with? 'closed').to_s,
        value: 'X'
      },
      B25: {
        desc: 'Dove, come è avvenuta la violazione dei dati?',
        condition: true,
        value: "Il sistema/servizio impattatto è stato colpito da un attacco di tipo #{@breach_types}"
      },
      B27: {
        desc: "Modalita' di esposizione al rischio",
        condition: (@breach_types.downcase.include? 'lettura dati').to_s,
        value: 'X'
      },
      B28: {
        desc: "Modalita' di esposizione al rischio",
        condition: (@breach_types.downcase.include? 'copia dati').to_s,
        value: 'X'
      },
      B29: {
        desc: "Modalita' di esposizione al rischio",
        condition: (@breach_types.downcase.include? 'alterazione dati').to_s,
        value: 'X'
      },
      B30: {
        desc: "Modalita' di esposizione al rischio",
        condition: (@breach_types.downcase.include? 'cancellazione dati').to_s,
        value: 'X'
      },
      B31: {
        desc: "Modalita' di esposizione al rischio",
        condition: (@breach_types.downcase.include? 'furto dati').to_s,
        value: 'X'
      },
      B35: {
        desc: 'Quante persone sono state colpite dalla violazione dei dati?',
        condition: (@impacted_people.downcase.start_with? 'n. xx persone').to_s,
        value: 'X'
      },
      B36: {
        desc: 'Quante persone sono state colpite dalla violazione dei dati?',
        condition: (@impacted_people.downcase.start_with? 'circa xx persone').to_s,
        value: 'X'
      },
      B37: {
        desc: 'Quante persone sono state colpite dalla violazione dei dati?',
        condition: (@impacted_people.downcase.start_with? 'ancora da determinare').to_s,
        value: 'X'
      },
      B39: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati anagrafici').to_s,
        value: 'X'
      },
      B40: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati di accesso e identificazione').to_s,
        value: 'X'
      },
      B41: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati relativi a minori').to_s,
        value: 'X'
      },
      B42: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati personali (origine razziale').to_s,
        value: 'X'
      },
      B43: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati personali (stato di salute').to_s,
        value: 'X'
      },
      B44: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Dati giudiziari').to_s,
        value: 'X'
      },
      B45: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Copia digitale di documenti analogici').to_s,
        value: 'X'
      },
      B46: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Ancora sconosciuto').to_s,
        value: 'X'
      },
      B47: {
        desc: 'Che tipo di dati sono oggetto di violazione?',
        condition: (@impacted_data_types.include? 'Altro').to_s,
        value: 'X'
      },
      B49: {
        desc: 'Livello di gravità della violazione dei dati',
        condition: (%w[immediata urgente].include? @priority.downcase).to_s,
        value: 'X'
      },
      B50: {
        desc: 'Livello di gravità della violazione dei dati',
        condition: (%w[alta normale].include? @priority.downcase).to_s,
        value: 'X'
      },
      B51: {
        desc: 'Livello di gravità della violazione dei dati',
        condition: (@priority.downcase.start_with? 'bassa').to_s,
        value: 'X'
      },
      B56: {
        desc: 'La violazione è stata comunicata anche agli interessati?',
        condition: @gdpr_data_owners_informed.to_s,
        value: 'X'
      },
      B57: {
        desc: 'La violazione è stata comunicata anche agli interessati?',
        condition: (!@gdpr_data_owners_informed).to_s,
        value: 'X'
      },
      B59: {
        desc: 'Qual è il contenuto della comunicazione resa agli interessati?',
        condition: true,
        value: 'TBD: Nota Comunic. Normativa'
      },
      B61: {
        desc: 'Quali misure tecnologiche e organizzative sono state assunte?',
        condition: true,
        value: "Misure tecnologiche: #{@technical_solution}. Misure organizzative: #{@organizational_solution}"
      }
    }
  end

  def pci_cpp_cpl
    {
      B4: {
        desc: 'Report date',
        condition: true,
        value: Date.today.strftime('%d/%m/%Y').to_s
      },
      B5: {
        desc: 'Incident ID, Date and Time',
        condition: true,
        value: "Incident ##{@id} [#{@start_date} - #{@time_of_incident}] - #{@subject}"
      },
      B7: {
        desc: 'Company',
        condition: true,
        value: @company.to_s
      },
      B8: {
        desc: 'Company Address',
        condition: true,
        value: @address.to_s
      },
      B10: {
        desc: 'Contact',
        condition: true,
        value: @manager.to_s
      },
      B11: {
        desc: 'Contact Role',
        condition: true,
        value: @manager_role.to_s
      },
      B12: {
        desc: 'Contact Email',
        condition: true,
        value: @manager_email.to_s
      },
      B13: {
        desc: 'Contact Phone',
        condition: true,
        value: @manager_phone.to_s
      },
      B15: {
        desc: 'Incident Reporter',
        condition: true,
        value: @author.to_s
      },
      B16: {
        desc: 'Incident Reporter Email',
        condition: true,
        value: @author_email.to_s
      },
      B17: {
        desc: 'Incident Reporter Phone',
        condition: true,
        value: 'N/A'
      },
      B23: {
        desc: 'Incident Details',
        condition: true,
        value: "Problema identificato: #{@identified_problem} - Analisi: #{@analysis} - Soluzione tecnica: #{@technical_solution}"
      },
      B25: {
        desc: 'Type of Data',
        condition: true,
        value: @impacted_data_types.to_s
      },
      B26: {
        desc: 'Identification of the source of the data',
        condition: true,
        value: @breach_origin.to_s
      }
    }
  end

  def nis
    {
      D45: {
        desc: 'Data e ora rilevamento',
        condition: true,
        value: "#{@issue_creation_date} - #{@issue_creation_time}"
      },
      D47: {
        desc: "Data e ora in cui si è verificato l'incidente (se note)",
        condition: true,
        value: "#{@start_date} - #{@time_of_incident}"
      },
      D49: {
        desc: "Durata dell'incidente",
        condition: true,
        value: @duration.to_s
      },
      D55: {
        desc: "Codice identificativo interno o nome dell'incidente (se applicabile)",
        condition: true,
        value: @incident_id.to_s
      },
      D57: {
        desc: 'Descrizione',
        condition: true,
        value: @breach_types.to_s
      },
      D62: {
        desc: 'Se sì, descrivere le cause:',
        condition: true,
        value: @breach_origin.to_s
      },
      D64: {
        desc: "Come è stato rilevato l'incidente?",
        condition: true,
        value: "Il ticket è stato aperto da #{@author} (#{@author_email})"
      },
      D66: {
        desc: "Stato dell'incidente all'atto della notifica",
        condition: (@status_id == 1).to_s,
        value: 'X'
      },
      D67: {
        desc: "Stato dell'incidente all'atto della notifica",
        condition: (@status_id == 6).to_s,
        value: 'X'
      },
      D68: {
        desc: "Stato dell'incidente all'atto della notifica",
        condition: (@status_id > 1 && @status_id < 6).to_s,
        value: 'X'
      },
      D70: {
        desc: "Reti, sistemi e funzioni incisi dall'incidente",
        condition: true,
        value: @psd2_impacted_systems.to_s
      },
      D74: {
        desc: 'Numero di utenti interessati',
        condition: true,
        value: @psd2_users.to_s
      },
      D79: {
        desc: 'Portata della perturbazione del funzionamento del servizio',
        condition: true,
        value: @psd2_transactions.to_s
      },
      D85: {
        desc: 'Numero di ore di indisponibilità del servizio',
        condition: true,
        value: @psd2_downtime.to_s
      },
      D87: {
        desc: "L'incidente ha causato una violazione dei dati personali?",
        condition: (!(@impacted_regulation.include? 'GDPR')).to_s,
        value: 'X'
      },
      D89: {
        desc: "L'incidente ha causato una violazione dei dati personali?",
        condition: "#{@impacted_regulation.include? 'GDPR'}}",
        value: 'X'
      },
      D91: {
        desc: 'Se sì, specificare:',
        condition: "#{@impacted_regulation.include? 'GDPR'}}",
        value: @impacted_data_types.to_s
      },
      D106: {
        desc: "Se sì, fornire la descrizione dell'impatto:",
        condition: true,
        value: @business_continuity_observations.to_s
      },
      D108: {
        desc: "Descrivere le azioni già intraprese per mitigare l'impatto dell'incidente",
        condition: true,
        value: "Soluzione tecnica: #{@technical_solution}. Soluzione organizzativa: #{@organizational_solution}."
      },
      D138: {
        desc: 'Denial of Service (DoS)',
        condition: (@breach_types.downcase.include? 'ddos').to_s,
        value: 'X'
      },
      D139: {
        desc: 'Distribuzione di malware',
        condition: (@breach_types.downcase.include? 'ransomware').to_s,
        value: 'X'
      },
      D140: {
        desc: 'Ransomware',
        condition: (@breach_types.downcase.include? 'ransomware').to_s,
        value: 'X'
      },
      D141: {
        desc: 'Trojans',
        condition: (@breach_types.downcase.include? 'trojan').to_s,
        value: 'X'
      },
      D142: {
        desc: 'Man-in-the-Middle',
        condition: (@breach_types.downcase.include? 'pretexting').to_s,
        value: 'X'
      },
      D143: {
        desc: 'Furto di identità',
        condition: (@breach_types.downcase.include? 'social engineering').to_s,
        value: 'X'
      },
      D144: {
        desc: 'Hacking',
        condition: true,
        value: 'X'
      },
      D145: {
        desc: 'Sfruttamento di vulnerabilità note o di',
        condition: (@breach_types.downcase.include? 'other vulnerability').to_s,
        value: 'X'
      },
      D149: {
        desc: 'Malfunzionamento SW',
        condition: (@breach_origin.downcase.include? 'problema applicativo').to_s,
        value: 'X'
      },
      D150: {
        desc: 'Interferenza con HW',
        condition: (@breach_origin.downcase.include? 'problema infrastrutturale').to_s,
        value: 'X'
      },
      D151: {
        desc: 'Malfunzionamento HW',
        condition: (@breach_origin.downcase.include? 'problema hardware').to_s,
        value: 'X'
      },
      D152: {
        desc: 'Danno fisico',
        condition: (@breach_origin.downcase.include? 'sabotaggio').to_s,
        value: 'X'
      },
      D153: {
        desc: 'Perdita o furto di materiale',
        condition: (@breach_origin.downcase.include? 'furto').to_s,
        value: 'X'
      },
      D200: {
        desc: 'Riportare ogni altra informazione ritenuta utile',
        condition: true,
        value: @incident_management_observations.to_s
      }
    }
  end

  def intesa
    {
      A5: {
        desc: 'Data incident',
        condition: true,
        value: "Incident del #{@start_date}"
      },
      A16: {
        desc: "Descrizione dell'evento",
        condition: true,
        value: "#{@subject}\n\n#{@description}"
      },
      A19: {
        desc: 'Cronologia degli eventi',
        condition: true,
        value: 'DA COMPILARE'
      },
      A22: {
        desc: 'Analisi degli eventi e delle cause',
        condition: true,
        value: @analysis
      },
      A25: {
        desc: 'Azioni correttive',
        condition: true,
        value: "A breve termine: #{@technical_solution}\nA medio/lungo termine: #{@organizational_solution}"
      },
      A29: {
        desc: "Individuazione dell'evento",
        condition: true,
        value: "L'anomalia è stata rilevata in data #{@start_date} da #{@author}"
      },
      A32: {
        desc: "Risoluzione dell'evento",
        condition: true,
        value: 'DA COMPILARE'
      }
    }
  end
end
