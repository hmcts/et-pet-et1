# encoding: utf-8

class ClaimPdfUploader < BaseUploader
  def filename
    if file && claimant
      name = "#{claimant.first_name}_#{claimant.last_name}".downcase
      "et1_#{name}.pdf"
    end
  end

  private def claimant
    model.primary_claimant
  end
end
