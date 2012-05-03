# strikeiron

strikeiron uses the Strikeiron Online Sales Tax API to calculate online sales tax to alleviate maintaining tax codes.

For more information on Strikeiron, Inc., go to http://www.strikeiron.com/.

[![Build Status](https://secure.travis-ci.org/drewtempelmeyer/strikeiron.png)](http://travis-ci.org/drewtempelmeyer/strikeiron)

## Installation

Add this line to your application's Gemfile:

    gem 'strikeiron'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install strikeiron

## Usage

Usage of strikeiron requires access to Strikeiron Online Sales Tax API.

#### 1. Configure the client

    Strikeiron.configure do |config|
      config.user_id  = 'your_strikeiron_user_id'
      config.password = 'your_password'
    end

#### 2. Obtaining a list of categories

Performing the category lookup does not count against your hits. For performance reasons, I recommend you keep a cached copy. A database is a good start.

    categories = Strikeiron.tax_categories
    # => [{:category=>"Alcohol", :category_id=>"01051000"}, {:category=>"Alcoholic Beverages", :category_id=>"01050000"}, {:category=>"Beer", :category_id=>"01052000"}, {:category=>"Books", :category_id=>"01501500"}, {:category=>"Charges necessary to complete sale other than delivery and installation", :category_id=>"04800000"}, ...]

#### 3. Calculate sales tax

    from  = Strikeiron::Address.new(:street_address => 'One Microsoft Way', :city => 'Redmond', :state => 'WA', :zip_code => '98052')
    to    = Strikeiron::Address.new(:street_address => '902 Broadway', :city => 'New York', :state => 'NY', :zip_code => '10010')
    items = [
      Strikeiron::TaxValue.new(:category_id => '01151605', :amount => 239.41),
      Strikeiron::TaxValue.new(:category_id => '01151605', :amount => 239.41)
    ]

    response = Strikeiron.sales_tax(
      :from       => from,
      :to         => to,
      :tax_values => items
    )
    # => #<Strikeiron::TaxResult @from=#<Strikeiron::Address @street_address="ONE MICROSOFT WAY", @city="REDMOND", @state="WA", @zip_code="98052">, @to=#<Strikeiron::Address @street_address="902 BROADWAY", @city="NEW YORK", @state="NY", @zip_code="10010-6041">, @tax_values=[#<Strikeiron::TaxValue @category="Computer Software (both prewritten and non-prewritten) delivered electronically", @category_id="01151605", @tax_amount=21.25, @jurisdictions=[#<Strikeiron::Jurisdiction @fips="36", @name="New York", @tax_amount=9.57>, #<Strikeiron::Jurisdiction @fips="CTD51000", @name="METRO COMMUTER TRANS. DISTRICT", @tax_amount=0.89>, #<Strikeiron::Jurisdiction @fips="061", @name="NEW YORK", @tax_amount=10.77>]>, #<Strikeiron::TaxValue @category="Computer Software (both prewritten and non-prewritten) delivered electronically", @category_id="01151605", @tax_amount=21.25, @jurisdictions=[#<Strikeiron::Jurisdiction @fips="36", @name="New York", @tax_amount=9.57>, #<Strikeiron::Jurisdiction @fips="CTD51000", @name="METRO COMMUTER TRANS. DISTRICT", @tax_amount=0.89>, #<Strikeiron::Jurisdiction @fips="061", @name="NEW YORK", @tax_amount=10.77>]>], @total_tax=42.5>

#### 4. Profit

Hopefully.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Furthermore

I am in no way associated with Strikeiron.
