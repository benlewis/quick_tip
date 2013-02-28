class MonthlyClientDatum < ActiveRecord::Base
  belongs_to :client

  attr_accessible :beginning_balance, :ending_balance, :month, :year, :client
  attr_protected :total_tips_count, :total_tips_cents, :total_tips_processing_fees, :total_tips_qt_cents

  # t.datetime :last_calculated_at
  # t.integer :beginning_balance
  # t.integer :ending_balance
  # t.integer :total_tips_count
  # t.integer :total_tips_cents
  # t.integer :total_tips_processing_fees_cents
  # t.integer :total_tips_qt_cents
  # t.integer :total_tips_qt_cents_client_cents
  # t.integer :total_payouts_count
  # t.integer :total_payouts_cents

  validates_presence_of :beginning_balance, :month, :year, :client

  validates_numericality_of :month, :in => 1..12, :only_integer => true
  validates_numericality_of :year, :in => 2013..2020, :only_integer => true
  validates_numericality_of :beginning_balance, :only_integer => true

  def month_dt
    DateTime.new(year, month, 1)
  end

  def month_range
    month_dt.beginning_of_month..month_dt.end_of_month
  end

  def calculate!
    now = DateTime.now

    tips = client.tips.where(:created_at => month_range, :status => 'valid')
    self.total_tips_count = tips.count
    self.total_tips_cents = tips.sum(&:total_cents)
    self.total_tips_processing_fees_cents = tips.sum(&:processing_fees_cents)
    self.total_tips_qt_cents = tips.sum(&:qt_cents)
    self.total_tips_client_cents = tips.sum(&:client_cents)

    payouts = client.payouts.where(:created_at => month_range, :status => 'valid')
    self.total_payouts_count = payouts.count
    self.total_payouts_cents = payouts.sum(&:cents)

    self.ending_balance = beginning_balance + total_tips_client_cents - total_payouts_cents
    self.last_calculated_at = now
    save!

    # Set the next month's beginning balance
    next_month = month_dt + 1.month
    next_monthly_data = client.monthly_client_data.where(:month => next_month.month, :year => next_month.year).first_or_initialize
    next_monthly_data.beginning_balance = ending_balance
    next_monthly_data.save!
  end

end
