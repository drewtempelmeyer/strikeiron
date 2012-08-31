module Strikeiron #:nodoc:
  # Returned after performing a tax calculation
  #
  # === Attributes
  # * <tt>from</tt> - The from Address.
  # * <tt>to</tt> - The to Address.
  # * <tt>tax_values</tt> - The TaxValue objects returned from Strikeiron.
  # * <tt>total_tax</tt> - The total tax amount to be applied.
  class TaxResult
    attr_accessor :from, :to, :tax_values, :total_tax

    # Initialize the TaxResult object with the given options
    def initialize(default_values = {})
      default_values.each { |key, value| self.send "#{key}=", value }
    end

    class << self
      # Convert the object from the Strikeiron response
      def from_soap(response)
        tax_values = []

        if response[:results][:tax_value_record].is_a?(Hash)
          record = response[:results][:tax_value_record]
          tax_values << TaxValue.new(
            :category      => record[:category],
            :category_id   => record[:category_id],
            :tax_amount    => record[:sales_tax_amount].to_f,
            :jurisdictions => record[:jurisdictions][:sales_tax_value_jurisdiction].map { |j| Jurisdiction.new(:fips => j[:fips], :name => j[:name], :tax_amount => j[:sales_tax_amount].to_f) }
          )
        else
          response[:results][:tax_value_record].each do |record|
            tax_values << TaxValue.new(
              :category      => record[:category],
              :category_id   => record[:category_id],
              :tax_amount    => record[:sales_tax_amount].to_f,
              :jurisdictions => record[:jurisdictions][:sales_tax_value_jurisdiction].map { |j| Jurisdiction.new(:fips => j[:fips], :name => j[:name], :tax_amount => j[:sales_tax_amount].to_f) }
            )
          end
        end

        new(
          :from       => Address.new(response[:resolved_from_address]),
          :to         => Address.new(response[:resolved_to_address]),
          :tax_values => tax_values,
          :total_tax  => tax_values.inject(0) { |sum, tax_value| sum + tax_value.tax_amount }
        )
      end
    end
  end
end
