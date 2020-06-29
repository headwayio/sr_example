FactoryBot.define do
  factory :attachment do
    attachable { nil }
    attachment_data { 'MyText' }
  end
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: attachments
#
#  attachable_id   :bigint
#  attachable_type :string
#  attachment_data :text
#  created_at      :datetime         not null
#  id              :bigint           not null, primary key
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_attachments_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective
