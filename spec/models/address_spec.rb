require 'rails_helper'

RSpec.describe Address, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: addresses
#
#  addressable_id   :bigint
#  addressable_type :string
#  city             :string
#  created_at       :datetime         not null
#  id               :bigint           not null, primary key
#  line1            :string
#  line2            :string
#  state            :string
#  updated_at       :datetime         not null
#  zip              :string
#
# Indexes
#
#  index_addresses_on_addressable_type_and_addressable_id  (addressable_type,addressable_id)
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective
