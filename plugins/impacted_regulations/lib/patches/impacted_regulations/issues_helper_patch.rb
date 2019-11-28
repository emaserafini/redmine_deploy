require_dependency 'issues_helper'

module ImpactedRegulations
  module IssuesHelperPatch
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def impact_fields_with_weights
        fields = [
          'Impatto Economico',
          'Impatto Reputazionale',
          'Impatto Compliancy'
        ]
        fields.map do |n|
          cf = IssueCustomField.where('lower(name) = ?', n.downcase).first
          next unless cf

          {
            id: cf.id,
            options: options_map(cf.possible_values_options)
          }
        end
      end

      def regulations_list
        [
          {
            id: 'pci-dss',
            name: 'PCI DSS',
            impact_levels: [0, 1]
          },
          {
            id: 'pci-cpp',
            name: 'PCI CPP',
            impact_levels: [0, 1]
          },
          {
            id: 'psd2',
            name: 'PSD2',
            impact_levels: [0, 1]
          },
          {
            id: 'gdpr',
            name: 'GDPR',
            impact_levels: [0, 1, 2]
          }
        ]
      end

      private

      def options_map(options)
        options.map.with_index do |arr, i|
          {
            id: arr[1],
            label: arr[0],
            weight: ((options.length - i).to_f / options.length.to_f * 100).to_i,
            impact_level: i
          }
        end
      end
    end
  end
end

IssuesHelper.send(:include, ImpactedRegulations::IssuesHelperPatch)
