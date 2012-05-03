require 'helper'
require 'yaml'

class TestRequests < Test::Unit::TestCase

  def test_get_sales_tax
    from = Strikeiron::Address.new(
      :street_address => 'One Microsoft Way',
      :city           => 'Redmond',
      :state          => 'WA',
      :zip_code       => '98052'
    )

    to = Strikeiron::Address.new(
      :street_address => '902 Broadway',
      :city           => 'New York',
      :state          => 'NY',
      :zip_code       => '10010'
    )

    items = [ Strikeiron::TaxValue.new(:category => '01151605', :amount => 239.41), Strikeiron::TaxValue.new(:category => '01151605', :amount => 239.41) ]
    VCR.use_cassette('sales tax') do
      response = Strikeiron.sales_tax(
        :from       => from,
        :to         => to,
        :tax_values => items
      )

      assert_equal Strikeiron::TaxResult, response.class
      assert_equal 2, response.tax_values.size
      assert_equal 42.5, response.total_tax
      assert_not_equal 0, response.tax_values[0].jurisdictions.size
    end
  end

  def test_tax_categories
    VCR.use_cassette('tax categories') do
      categories = Strikeiron.tax_categories
      assert_not_equal [], categories
      assert_equal true, categories[0].has_key?(:category)
      assert_equal true, categories[0].has_key?(:category_id)
    end
  end

  def test_remaining_hits
    VCR.use_cassette('remaining hits') do
      remaining_hits = Strikeiron.remaining_hits
      assert_equal Fixnum, remaining_hits.class
    end
  end

end
