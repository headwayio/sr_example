FactoryBot.define do
  factory :authentication_token do
    body { 'MyString' }
    user { nil }
    last_used_at { '2018-03-06 14:53:42' }
    ip_address { 'MyString' }
    user_agent { 'MyString' }
  end
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: authentication_tokens
#
#  body         :string
#  created_at   :datetime         not null
#  id           :bigint           not null, primary key
#  ip_address   :string
#  last_used_at :datetime
#  updated_at   :datetime         not null
#  user_agent   :string
#  user_id      :bigint
#
# Indexes
#
#  index_authentication_tokens_on_user_id  (user_id)
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective
