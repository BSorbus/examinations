class AddOtherPdfBlobPathToProposal < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :other_pdf_blob_path, :text
  end
end
