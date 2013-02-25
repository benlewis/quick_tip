class Tip < ActiveRecord::Base
  belongs_to :payment, :polymorphic => true
  belongs_to :client

  PAYMENT_TYPES = %w(FakeTipPayment)
  STATUSES = %w(valid invalid)

  attr_accessible  :client, :payment, :status, :total_cents, :processing_fees_cents
  attr_protected :client_cents, :qt_cents

  validates_presence_of :client, :total_cents, :processing_fees_cents, :qt_cents, :client_cents, :status, :payment
  validates_inclusion_of :payment_type, :in => PAYMENT_TYPES
  validates_inclusion_of :status, :in => STATUSES
  validate :cents_add_up

  before_create :set_defaults
  before_create :calculate_profits

  def set_defaults
    self.status ||= 'valid'
  end

  def calculate_profits
    total_profit = total_cents - processing_fees_cents
    self.qt_cents = (total_profit * client.qt_pct).floor
    self.client_cents = total_profit - qt_cents
  end

  def cents_add_up
    if total_cents != processing_fees_cents + client_cents + qt_cents
      errors.add(:total_cents, 'Is not the sum of processing fees, qt cents, and client cents')
    end
  end

end
