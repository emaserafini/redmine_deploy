module ExportIncidentReport
  module IssuePatch
    def self.included(base)
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def get_custom_field_value(cfield_name, should_return_ids = false)
        cfield = IssueCustomField.find_by_name(cfield_name)
        raw_val = custom_field_value(cfield.id)
        raw_val.empty? ? '' : get_cleaned_up_value(raw_val, cfield, should_return_ids)
      rescue StandardError
        '<VALUE OR FIELD NOT FOUND>'
      end

      def send_chain(arr)
        arr.inject(self) do |o, a|
          if a.is_a? Array
            o.send(a[0].to_sym, *a.drop(1))
          else
            o.send(a)
          end
        end
      end

      def get_incident_type
        cat = get_custom_field_value('category').downcase
        avaria = get_custom_field_value('sistemi di controllo impattati').downcase
        if cat == 'security' || avaria == 'sì (avaria)'
          'Di sicurezza'
        else
          'Operativo'
        end
      end

      def get_incident_cause
        status = self.status.name.downcase
        analisi = get_custom_field_value('analisi / analisi forense').strip
        if status == 'inc 4. comunicato / in corso' || analisi == ''
          'In fase di analisi.'
        else
          'TODO'
        end
      end
    end

    private

    def get_cleaned_up_value(val, cfield, should_return_ids)
      options = cfield.possible_values_options
      case cfield
      when enumeration_single? then get_enumeration_value(val, options, should_return_ids)
      when enumeration_multiple? then val.map { |v| get_enumeration_value(v, options, should_return_ids) }.join(', ')
      when user? then User.find(val).name
      when boolean? then val == '1'
      when recognized_field? then val
      else '<FIELD FORMAT NOT RECOGNISED>'
      end
    end

    def enumeration_single?
      ->(cfield) { cfield.field_format == 'enumeration' && !cfield.multiple }
    end

    def enumeration_multiple?
      ->(cfield) { cfield.field_format == 'enumeration' && cfield.multiple }
    end

    def user?
      ->(cfield) { cfield.field_format == 'user' }
    end

    def boolean?
      ->(cfield) { cfield.field_format == 'bool' }
    end

    def recognized_field?
      ->(cfield) { %w[list date string text].include? cfield.field_format }
    end

    def get_enumeration_value(val, options, should_return_ids)
      option = options.find { |opt| opt[1] == val }[0]
      if should_return_ids
        option.match(/^(\d+)(.*)/)[1].to_i
      else
        option.gsub(/\A\d+. /, '')
      end
    end
  end
end

Issue.send(:include, ExportIncidentReport::IssuePatch)
