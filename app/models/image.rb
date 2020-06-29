class Image < ApplicationRecord
  # adds an `image` virtual attribute
  include ::PhotoUploader::Attachment.new(:image)

  belongs_to :attachable, polymorphic: true, required: false
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: images
#
#  attachable_id   :bigint
#  attachable_type :string
#  created_at      :datetime         not null
#  id              :bigint           not null, primary key
#  image_data      :text
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_images_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
# rubocop:enable Metrics/LineLength, Lint/UnneededCopDisableDirective
