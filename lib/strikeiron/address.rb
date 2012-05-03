module Strikeiron #:nodoc:

  # An Address stores information of a physical location for both the seller and customer.
  #
  # === Attributes
  # * <tt>street_address</tt> - The full street address for the seller/customer. Example: 123 Sixth Avenue.
  # * <tt>city</tt> - The city of the address.
  # * <tt>state</tt> - The two letter abbreviation for the state. Example: NY.
  # * <tt>zip_code</tt> - The postal/ZIP code of the address.
  class Address

    attr_accessor :street_address, :city, :state, :zip_code

    # Creates an Address with the supplied attributes.
    def initialize(default_values = {})
      safe_keys = %w(street_address city state zip_code)
      # Only permit the keys defined in safe_keys
      default_values.reject! { |key, value| !safe_keys.include?(key.to_s) }

      default_values.each { |key, value| self.send "#{key}=", value }
    end

    # Convert the object to a Hash for SOAP
    def to_soap
      {
        'StreetAddress' => street_address,
        'City'          => city,
        'State'         => state,
        'ZIPCode'       => zip_code
      }
    end

    class << self
      # Convert the object from a SOAP response to an Address object
      def from_soap(hash = {})
        default_values = {
          :street_address => hash['StreetAddress'],
          :city           => hash['City'],
          :state          => hash['State'],
          :zip_code       => hash['ZIPCode']
        }
        new(default_values)
      end
    end

  end
end
