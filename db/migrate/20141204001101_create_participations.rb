class CreateParticipations < ActiveRecord::Migration
  def self.up
  	create_table :participations do |t|
      t.references :comic
      t.references :character
    end
  end

  def self.down
    drop_table :participations
  end
end
