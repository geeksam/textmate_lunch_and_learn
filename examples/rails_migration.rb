class AddPhoneNumberToIncentives < ActiveRecord::Migration
  def self.up
    add_column :incentives, :phone, :string
  end

  def self.down
    remove_column :incentives, :phone
  end
end

