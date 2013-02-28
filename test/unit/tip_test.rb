require 'test_helper'

class TipTest < ActiveSupport::TestCase

  def setup
    @client = Client.create(:name => 'test', :short_name => 'tt', :qt_pct => 0.10)
  end

  def create_fake_tip
    FakeTipPayment.create_with_tip!(@client, {
      :total_cents => 100,
      :processing_fees_cents => 35,
      :code => 'asdf'
    })
  end

  test "create tip" do
    10.times { create_fake_tip }
    assert_equal 10, @client.tips.count

    tip = @client.tips.first
    assert_equal 100, tip.total_cents
    assert_equal 35, tip.processing_fees_cents
    assert_equal 6, tip.qt_cents
    assert_equal 59, tip.client_cents
  end

  test "invalidate" do
    create_fake_tip
    assert_equal 1, @client.tips.count

    tip = @client.tips.first
    tip.invalidate!

    assert_equal 0, @client.tips.count
  end

  def teardown
    @client.destroy
  end

end
