require 'test_helper'

class UserDropTest < ActiveSupport::TestCase
  DELEGATIONS = [
    :name,
    :email,
    :address,
  ]

  setup do
    @user = users(:flo)
    @drop = @user.to_liquid
  end

  test 'User#to_liquid returns a UserDrop' do
    assert @user.to_liquid.is_a?(UserDrop)
    assert @user.to_liquid.is_a?(Liquid::Drop)
  end

  DELEGATIONS.each do |method|
    test "#{method} is delegated to user" do
      assert_equal @user.public_send(method), @drop.public_send(method)
    end
  end
end
