require "savon"
require "strikeiron/version"
require "strikeiron/configuration"
require "strikeiron/address"
require "strikeiron/tax_value"
require "strikeiron/jurisdiction"
require "strikeiron/tax_result"

# Strikeiron calculates online sales tax for your online service based on your local tax rules.
module Strikeiron

  # The location of the Strikeiron Online Sales Tax WSDL
  WSDL = 'https://wsparam.strikeiron.com/SpeedTaxSalesTax3?WSDL'

  class << self
    attr_accessor :configuration

    # Configure Strikeiron for your account. See Configuration for more information.
    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end

    # Singleton Savon client
    def client
      @@client ||= Savon.client(:wsdl => WSDL, :ssl_version => :SSLv3, :ssl_verify_mode => :none,
                                :log => configuration.logging)
    end

    # Get the calculated online sales tax for a product or service
    #
    # === Options
    # * <tt>from</tt> - The origin Address (or your physical location). Required.
    # * <tt>to</tt> - The destination Address of the customer. Required.
    # * <tt>tax_values</tt> - An array of TaxValueRequest objects. Required.
    def sales_tax(options = {})
      options          = options.inject({}) { |memo,(k, v)| memo[k.to_sym] = v; memo }
      required_options = %w(from to tax_values)

      # Raise an error if the required option is not defined
      required_options.each { |val| raise ArgumentError, "Missing option :#{val}" if !options.include?(val.to_sym) }

      response = client.call(:get_sales_tax_value, :message => {
        'UserID'          => configuration.user_id,
        'Password'        => configuration.password,
        'ShipFrom'        => options[:from].to_soap,
        'ShipTo'          => options[:to].to_soap,
        'TaxValueRequests' => { 'TaxValueRequest' => options[:tax_values].map(&:to_soap) }
      })

      response_code = response.body[:get_sales_tax_value_response][:get_sales_tax_value_result][:service_status][:status_nbr]

      # Raise exceptions if there was an error when calculating the tax
      case response_code.to_i
      when 401
        raise RuntimeError, 'Invalid From address.'
      when 402
        raise RuntimeError, 'Invalid To address.'
      when 403
        raise RuntimeError, 'Invalid Taxability category.'
      when 500
        raise RuntimeError, 'Internal Strikeiron server error.'
      end

      Strikeiron::TaxResult.from_soap(response.body[:get_sales_tax_value_response][:get_sales_tax_value_result][:service_result])
    end

    # Performs a request to obtain a list of all available category names and their corresponding ID number.
    #
    # === Example
    #   Strikeiron.tax_categories
    #   # => [{:category=>"Alcohol", :category_id=>"01051000"}, {:category=>"Alcoholic Beverages", :category_id=>"01050000"}, {:category=>"Beer", :category_id=>"01052000"}, {:category=>"Books", :category_id=>"01501500"}, {:category=>"Charges necessary to complete sale other than delivery and installation", :category_id=>"04800000"}]
    def tax_categories
      response = client.call(:get_sales_tax_categories, :message => {
        'UserID'   => configuration.user_id,
        'Password' => configuration.password
      })

      # Return an empty array if the response was not successful
      return [] if response.body[:get_sales_tax_categories_response][:get_sales_tax_categories_result][:service_status][:status_nbr] != '200'

      response.body[:get_sales_tax_categories_response][:get_sales_tax_categories_result][:service_result][:sales_tax_category]
    end

    # The number of API hits remanining for the configured account
    #
    # === Example
    #   Strikeiron.remaining_hits
    #   # => 100
    def remaining_hits
      response = client.call(:get_remaining_hits, :message => {
        'UserID'   => configuration.user_id,
        'Password' => configuration.password
      })

      response.body[:si_subscription_info][:remaining_hits].to_i
    end

  end

end
