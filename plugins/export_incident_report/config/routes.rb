post 'incident_reports/:issue_id', to: 'incident_reports#create', as: 'incident_reports'
get 'incident_reports/download', to: 'incident_reports#download', as: 'download_report'
