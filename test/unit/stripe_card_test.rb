require 'test_helper'

class StripeCardTest < ActiveSupport::TestCase

  def setup
    @client = FactoryGirl.create(:client, service_pct: 10.0)
  end

  def teardown
    @client.destroy
  end

  def create_stripe_tip
    VCR.use_cassette('create_stripe_card_tip') do
      FactoryGirl.create(:stripe_card_tip, charge_client: @client)
    end
  end

  test "create tip" do
    10.times { create_stripe_tip }
    assert_equal 10, @client.tips.count

    tip = @client.tips.first
    assert_equal 100, tip.total_cents
    assert_equal 33, tip.processing_fees_cents
    assert_equal 6, tip.service_cents
    assert_equal 61, tip.client_cents
  end

  test "invalidate" do
    create_stripe_tip
    assert_equal 1, @client.tips.count

    tip = @client.tips.first
    tip.invalidate!

    assert_equal 0, @client.tips.count
  end

end
