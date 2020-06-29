module AddressFields
  extend ActiveSupport::Concern

  included do
    has_one :address,
            as: :addressable,
            inverse_of: :addressable,
            dependent: :destroy

    accepts_nested_attributes_for :address

    delegate :line1, :line2, :city, :state, :zip,
             to: :address, prefix: true, allow_nil: true
  end

  def display_address
    output = ''
    output << "#{address.line1}<br>"
    output << "#{address.line2}<br>" if address.line2.present?
    output << "#{address.city}, #{address.state} #{address.zip}"
    output.html_safe
  end
end
