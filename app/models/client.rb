class Client < ActiveRecord::Base
  has_many :monthly_client_data
  has_many :users
  has_many :tips, :conditions => { :status => 'valid' }
  has_many :payouts, :conditions => { :status => 'valid' }

  attr_accessible :name

  validates_presence_of :name, :qt_pct
  validates_numericality_of :qt_pct, :in => 0.00..1.00

  after_create :create_first_monthly_client_data

  def create_first_monthly_client_data
    now = DateTime.now
    monthly_client_data.create!(:month => now.month, :year => now.year, :beginning_balance => 0)
  end

end
