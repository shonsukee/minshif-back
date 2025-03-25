class AddShiftSubmissionRequestIdToShift < ActiveRecord::Migration[7.0]
  def change
    add_column :shifts, :shift_submission_request_id, :bigint, comment: "シフト提出依頼の外部キー"
    add_index :shifts, :shift_submission_request_id
    add_foreign_key :shifts, :shift_submission_requests, column: :shift_submission_request_id
  end
end
