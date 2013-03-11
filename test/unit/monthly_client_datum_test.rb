require 'test_helper'

class MonthlyClientDataTest < ActiveSupport::TestCase

  def setup
    @client = Client.create(:name => 'test', :short_name => 'tt', :service_pct => 10.0)
  end

  def create_fake_tip
    FakeTipPayment.create_with_tip!(@client, {
      :total_cents => 100,
      :processing_fees_cents => 35,
      :code => 'asdf'
    })
  end

  def create_fake_payout
    FakePayoutVehicle.create_with_payout!(@client, {
      :cents => 75
    })
  end

  test "calculate with tips and payouts" do
    10.times { create_fake_tip }
    assert_equal 10, @client.tips.count

    tip = @client.tips.first
    assert_equal 100, tip.total_cents
    assert_equal 35, tip.processing_fees_cents
    assert_equal 6, tip.service_cents
    assert_equal 59, tip.client_cents

    monthly_client_datum = @client.current_monthly_datum
    monthly_client_datum.calculate!
    assert_equal 0, monthly_client_datum.beginning_balance
    assert_equal 10, monthly_client_datum.total_tips_count
    assert_equal 10 * 100, monthly_client_datum.total_tips_cents
    assert_equal 10 * 35, monthly_client_datum.total_tips_processing_fees_cents
    assert_equal 10 * 6, monthly_client_datum.total_tips_service_cents
    assert_equal 10 * 59, monthly_client_datum.total_tips_client_cents
    assert_equal 10 * 59, monthly_client_datum.ending_balance

    create_fake_payout
    monthly_client_datum.calculate!
    assert_equal 1, monthly_client_datum.total_payouts_count
    assert_equal 75, monthly_client_datum.total_payouts_cents
    assert_equal 10 * 59 - 75, monthly_client_datum.ending_balance

    next_month = monthly_client_datum.month_dt + 1.month
    next_monthly_client_datum = @client.monthly_client_data.first(:conditions => { :month => next_month.month, :year => next_month.year })
    assert_equal monthly_client_datum.ending_balance, next_monthly_client_datum.beginning_balance
  end

  def teardown
    @client.destroy
  end

end
