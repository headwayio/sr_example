FactoryBot.define do
  factory :address do
    addressable { nil }
    city { Faker::Address.city }
    line1 { Faker::Address.street_address }
    line2 { Faker::Address.secondary_address }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
  end
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
