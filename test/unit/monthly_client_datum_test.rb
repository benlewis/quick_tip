require 'test_helper'

class MonthlyClientDataTest < ActiveSupport::TestCase

  def setup
    @client = FactoryGirl.create(:client, service_pct: 10.0)
  end

  def create_stripe_tip
    VCR.use_cassette('create_stripe_card_tip_for_monthly_payout') do
      FactoryGirl.create(:stripe_card_tip, charge_client: @client)
    end
  end

  def create_fake_payout
    FakePayoutVehicle.create_with_payout!(@client, {
      :cents => 75
    })
  end

  test "calculate with tips and payouts" do
    10.times { create_stripe_tip }
    assert_equal 10, @client.tips.count

    tip = @client.tips.first
    assert_equal 100, tip.total_cents
    assert_equal 33, tip.processing_fees_cents
    assert_equal 6, tip.service_cents
    assert_equal 61, tip.client_cents

    monthly_client_datum = @client.current_monthly_datum
    monthly_client_datum.calculate!
    assert_equal 0, monthly_client_datum.beginning_balance
    assert_equal 10, monthly_client_datum.total_tips_count
    assert_equal 10 * 100, monthly_client_datum.total_tips_cents
    assert_equal 10 * 33, monthly_client_datum.total_tips_processing_fees_cents
    assert_equal 10 * 6, monthly_client_datum.total_tips_service_cents
    assert_equal 10 * 61, monthly_client_datum.total_tips_client_cents
    assert_equal 10 * 61, monthly_client_datum.ending_balance

    create_fake_payout
    monthly_client_datum.calculate!
    assert_equal 1, monthly_client_datum.total_payouts_count
    assert_equal 75, monthly_client_datum.total_payouts_cents
    assert_equal 10 * 61 - 75, monthly_client_datum.ending_balance

    next_month = monthly_client_datum.month_dt + 1.month
    next_monthly_client_datum = @client.monthly_client_data.first(:conditions => { :month => next_month.month, :year => next_month.year })
    assert_equal monthly_client_datum.ending_balance, next_monthly_client_datum.beginning_balance
  end

  def teardown
    @client.destroy
  end

end
