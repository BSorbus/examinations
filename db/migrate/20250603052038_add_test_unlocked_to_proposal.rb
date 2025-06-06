class AddTestUnlockedToProposal < ActiveRecord::Migration[5.2]
  def change
    add_column :proposals, :test_unlocked, :boolean, null: false, default: false
  end
end
