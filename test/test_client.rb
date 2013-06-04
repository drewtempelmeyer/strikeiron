require 'helper'

class TestClient < Test::Unit::TestCase

  def test_client_exists
    assert_not_equal nil, Strikeiron.client
  end

  def test_client_actions
    VCR.use_cassette('client actions') do
      actions = Strikeiron.client.operations
      supported_actions = %w(get_sales_tax_value get_sales_tax_categories get_remaining_hits)
      supported_actions.each do |action|
        assert_equal true, actions.include?(action.to_sym)
      end
    end
  end

end
