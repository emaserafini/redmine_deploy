class Psd2
  attr_reader :info, :major_incident

  def initialize
    field_names = [
      'PSD2 Alta escalation interna',
      'PSD2 Altri PSP interessati',
      'PSD2 Impatto economico',
      'PSD2 Impatto sulla reputazione',
      'PSD2 Major incident',
      'PSD2 Periodo indisp. servizio',
      'PSD2 Transazioni interessate',
      'PSD2 Utenti interessati'
    ]

    @fields = IssueCustomField.where(name: field_names).order(:name)

    @info = [
      escalation,
      psp,
      impatto,
      reputazione,
      periodo,
      transazioni,
      utenti
    ]

    @major_incident = @fields[4].id if @fields[4]
  end

  private

  def escalation
    return unless @fields[0]

    {
      id: @fields[0].id,
      desc: @fields[0].name,
      major_impact: @fields[0].possible_values_options[1][1],
      minor_impact: @fields[0].possible_values_options[0][1]
    }
  end

  def psp
    return unless @fields[1]

    {
      id: @fields[1].id,
      desc: @fields[1].name,
      major_impact: nil,
      minor_impact: @fields[1].possible_values_options[0][1]
    }
  end

  def impatto
    return unless @fields[2]

    {
      id: @fields[2].id,
      desc: @fields[2].name,
      major_impact: @fields[2].possible_values_options[0][1],
      minor_impact: nil
    }
  end

  def reputazione
    return unless @fields[3]

    {
      id: @fields[3].id,
      desc: @fields[3].name,
      major_impact: nil,
      minor_impact: @fields[3].possible_values_options[0][1]
    }
  end

  def periodo
    return unless @fields[5]

    {
      id: @fields[5].id,
      desc: @fields[5].name,
      major_impact: nil,
      minor_impact: @fields[5].possible_values_options[0][1]
    }
  end

  def transazioni
    return unless @fields[6]

    {
      id: @fields[6].id,
      desc: @fields[6].name,
      major_impact: @fields[6].possible_values_options[0][1],
      minor_impact: @fields[6].possible_values_options[1][1]
    }
  end

  def utenti
    return unless @fields[7]

    {
      id: @fields[7].id,
      desc: @fields[7].name,
      major_impact: @fields[7].possible_values_options[0][1],
      minor_impact: @fields[7].possible_values_options[1][1]
    }
  end
end
