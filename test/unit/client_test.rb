require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  def ggds
    {
      name: 'Golden Gate Disc Golf',
      short_name: 'ggds',
      qt_pct: 0.05
    }
  end

  test "can create clients" do
    c = Client.create ggds
    assert c.errors.none?
    assert Client.find_by_short_name(ggds[:short_name])
  end

  test "client creates monthly data" do
    c = Client.create ggds
    assert_equal c.monthly_client_data.count, 1
  end

end
