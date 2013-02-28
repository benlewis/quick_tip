require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "maps too client" do
    client = Client.create(:name => 'test', :short_name => 'tt', :qt_pct => 0.05)
    user = User.create(:email => 'test@example.com', :password => 'asdf1234', :password_confirmation => 'asdf1234', :client => client)
    assert user.errors.none?

    assert_equal user.client, client
  end

end
