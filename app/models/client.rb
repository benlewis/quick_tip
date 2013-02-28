class Client < ActiveRecord::Base
  has_many :monthly_client_data
  has_many :users
  has_many :tips, :conditions => { :status => 'valid' }
  has_many :payouts, :conditions => { :status => 'valid' }

  attr_accessible :name, :short_name, :qt_pct

  validates_presence_of :name, :short_name, :qt_pct
  validates_uniqueness_of :name, :short_name
  validates_numericality_of :qt_pct, :greater_than_or_equal_to => 0.00, :less_than_or_equal_to => 1.00
  validates_length_of :short_name, :within => 2..10

  after_create :create_first_monthly_client_data

  def create_first_monthly_client_data
    now = DateTime.now
    monthly_client_data.create!(:month => now.month, :year => now.year, :beginning_balance => 0)
  end

  def current_monthly_datum
    now = DateTime.now
    monthly_client_data.first(:conditions => { :month => now.month, :year => now.year })
  end

end
