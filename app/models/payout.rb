class Payout < ActiveRecord::Base
  belongs_to :client
  belongs_to :vehicle, :polymorphic => true

  attr_accessible :status, :total_cents

  STATUSES = %w(valid invalid)
  VEHICLE_TYPES = %w(FakePayoutVehicle)

  validates_presence_of :client, :cents, :status
  validates_inclusion_of :status, :in => STATUSES
  validates_numericality_of :cents, :only_integer => true, :greater_than => 0

end
