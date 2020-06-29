# rubocop:disable Style/MixinUsage
include ActionDispatch::TestProcess
# rubocop:enable Style/MixinUsage

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    uuid { SecureRandom.uuid }
    password { 'asdfjkl123' }
    password_confirmation { 'asdfjkl123' }
    sequence :email do |n|
      "user#{n}@example.com"
    end

    photo do
      fixture_file_upload(
        Rails.root.join('spec', 'fixtures', 'avatar.svg'),
        'image/svg',
      )
    end

    trait :admin do
      roles { [:admin] }
      first_name { 'Admin' }
      last_name { 'User' }
      email { "admin_#{uuid}@example.com" }
    end

    after(:create) do |user|
      FactoryBot.create(
        :address,
        addressable_id: user.id,
        addressable_type: 'User',
      )
    end
  end
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: users
#
#  bio                    :text
#  birthdate              :date
#  company                :string
#  country_field          :string
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  device_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :bigint           not null, primary key
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_id          :bigint
#  invited_by_type        :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  photo_data             :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  roles_mask             :integer
#  sign_in_count          :integer          default(0), not null
#  title                  :string
#  updated_at             :datetime         not null
#  uuid                   :string
#
# Indexes
#
#  index_users_on_deleted_at                         (deleted_at)
#  index_users_on_email_and_deleted_at               (email, COALESCE(deleted_at, 'infinity'::timestamp without time zone)) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective
