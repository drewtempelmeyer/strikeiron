module Strikeiron #:nodoc:
  # Total sales tax rate based on the dollar amount and category from TaxValueRequest.
  # TaxValueRecord should only be rendered from a SOAP response.
  #
  # === Attributes
  # * <tt>category</tt> - The corresponding category name. A category name and/or ID must be supplied.
  # * <tt>category_id</tt> - The corresponding category ID. A category name and/or ID must be supplied.
  # * <tt>amount</tt> - The amount to calculate the tax for.
  # * <tt>tax_amount</tt> - The combined sales tax rate based on the address and tax category provided
  #
  # === Notes
  # See Strikeiron.tax_categories for information on obtaining category information.
  class TaxValue
    attr_accessor :category, :category_id, :amount, :tax_amount, :jurisdictions

    # Creates a TaxValueRecord with the supplied attributes.
    def initialize(default_values = {})
      safe_keys = %w(category category_id amount tax_amount jurisdictions)
      # Only permit the keys defined in safe_keys
      default_values.reject! { |key, value| !safe_keys.include?(key.to_s) }

      default_values.each { |key, value| self.send "#{key}=", value }
    end

    # Convert the object to be valid for the SOAP request
    def to_soap
      {
        'SalesTaxCategoryOrCategoryID' => category || category_id,
        'Amount'                       => amount
      }
    end

    class << self
      # Convert the SOAP response object to a TaxValueRecord
      def from_soap(hash = {})
        default_values = {
          :category    => hash['Category'],
          :category_id => hash['CategoryID'],
          :tax_amount  => hash['SalesTaxAmount']
        }

        new(default_values)
      end
    end
  end
end
