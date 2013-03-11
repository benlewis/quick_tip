require 'test_helper'

class PayoutTest < ActiveSupport::TestCase

  def setup
    @client = Client.create(:name => 'test', :short_name => 'tt', :service_pct => 10.0)
  end

  def create_fake_payout
    FakePayoutVehicle.create_with_payout!(@client, {
      :cents => 75
    })
  end

  test "create payout" do
    10.times { create_fake_payout }
    assert_equal 10, @client.payouts.count

    payout = @client.payouts.first
    assert_equal 75, payout.cents
  end

  test "invalidate" do
    create_fake_payout
    assert_equal 1, @client.payouts.count

    payout = @client.payouts.first
    assert_equal 75, payout.cents

    payout.invalidate!
    assert_equal 0, @client.payouts.count
  end

  def teardown
    @client.destroy
  end

end
