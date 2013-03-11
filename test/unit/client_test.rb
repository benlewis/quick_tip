require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  test "can create clients" do
    c = FactoryGirl.create(:client)
    assert c.errors.none?

    attributes = FactoryGirl.attributes_for(:client)
    assert Client.find_by_short_name(attributes[:short_name])
  end

  test "client creates monthly data" do
    c = FactoryGirl.create(:client)
    assert_equal c.monthly_client_data.count, 1
  end

end
