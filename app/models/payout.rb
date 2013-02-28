class Payout < ActiveRecord::Base
  belongs_to :client
  belongs_to :vehicle, :polymorphic => true

  attr_accessible :status, :cents, :client, :vehicle

  STATUSES = %w(valid invalid)
  VEHICLE_TYPES = %w(FakePayoutVehicle)

  validates_presence_of :client, :cents, :status
  validates_inclusion_of :status, :in => STATUSES
  validates_numericality_of :cents, :only_integer => true, :greater_than => 0

  before_create :set_defaults

  def set_defaults
    self.status ||= 'valid'
  end

  def invalidate!
    self.status = 'invalid'
    save!
  end

end
