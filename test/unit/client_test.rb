require 'test_helper'

class ClientTest < ActiveSupport::TestCase

  test "can create clients" do
    puts Client.all.map(&:name)
  end

end
