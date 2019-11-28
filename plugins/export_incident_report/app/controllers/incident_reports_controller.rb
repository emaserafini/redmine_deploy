class IncidentReportsController < ApplicationController
  def create
    # workaround to open new window and download report from there.
    # if send_data was called here the page would be re rendered and the form would not be submittable the second time

    if params[:report_type].empty?
      render nothing: true
    else
      @download_url = download_report_path(
        issue_id: params[:issue_id],
        report_type: params[:report_type],
        report_filename: params[:report_filename]
      )

      respond_to do |format|
        format.js { render partial: 'download_report' }
      end
    end
  end

  def download
    report = IncidentReport.new(
      params[:issue_id],
      params[:report_type],
      params[:report_filename]
    )

    send_data(
      report.workbook.string,
      filename: report.filename,
      disposition: 'attachment'
    )
  end
end
