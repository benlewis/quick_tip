class Tip < ActiveRecord::Base
  belongs_to :payment_method, :polymorphic => true
  belongs_to :client

  PAYMENT_METHOD_TYPES = %w(StripeCard)
  STATUSES = %w(valid invalid)

  attr_accessible  :client, :payment_method, :status, :total_cents, :processing_fees_cents
  attr_protected :client_cents, :service_cents

  validates_presence_of :client, :total_cents, :processing_fees_cents, :service_cents, :client_cents, :status, :payment_method
  validates_inclusion_of :payment_method_type, :in => PAYMENT_METHOD_TYPES
  validates_inclusion_of :status, :in => STATUSES
  validate :cents_add_up

  before_validation :set_defaults
  before_validation :calculate_profits

  after_commit :update_monthly_data

  def set_defaults
    self.status ||= 'valid'
  end

  def calculate_profits
    total_profit = total_cents - processing_fees_cents
    self.service_cents = (total_profit * client.service_pct / 100.0).floor
    self.client_cents = total_profit - service_cents
  end

  def cents_add_up
    if total_cents != processing_fees_cents + client_cents + service_cents
      errors.add(:total_cents, 'Is not the sum of processing fees, service cents, and client cents')
    end
  end

  def invalidate!
    self.status = 'invalid'
    save!
  end

  def update_monthly_data
    # TODO: Put this in a queue
    client.current_monthly_datum(created_at).calculate!
  end

end
