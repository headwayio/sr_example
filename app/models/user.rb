class User < ApplicationRecord
  # adds an `photo` virtual attribute
  include ::PhotoUploader::Attachment.new(:photo)

  acts_as_paranoid
  include AddressFields

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable

  has_many :authentication_tokens, dependent: :destroy
  has_many :addresses, as: :addressable
  has_many :messages

  before_create :generate_uuid

  attr_accessor :unencrypted_token

  # Permissions cascade/inherit through the roles listed below. The order of
  # this list is important, it should progress from least to most privelage
  ROLES = [:admin].freeze
  acts_as_user roles: ROLES
  roles ROLES

  validates :email,
            presence: true,
            format: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,8}\z/i

  # NOTE: these password validations won't run if the user has an invite token
  validates :password,
            presence: true,
            length: { within: 8..72 },
            confirmation: true,
            on: :create
  validates :password_confirmation,
            presence: true,
            on: :create

  PASSWORD_FORMAT_MESSAGE =
    'Password must be between 8 and 72 characters'.freeze

  def tester?
    (email =~ /(example.com|headway.io)$/).present?
  end

  def send_push_notification(message, type)
    rpush_app = Rpush::Apns::App.find_by(name: 'ios_app')
    return if rpush_app.blank? || device_token.blank?

    notification = Rpush::Apns::Notification.new

    notification.app = rpush_app
    notification.device_token = device_token
    notification.alert = message
    notification.data = { type: type }
    notification.save!
  end

  def name
    [first_name, last_name].join(" ")
  end

  def photo_data_uri=(uri)
    return if uri.nil?
    super(uri)
  end

  private

  def generate_uuid
    loop do
      uuid = SecureRandom.uuid
      self.uuid = uuid
      break unless User.exists?(uuid: uuid)
    end
  end
end

# rubocop:disable Metrics/LineLength, Lint/UnneededCopDisableDirective
# == Schema Information
#
# Table name: users
#
#  birthdate              :date
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  device_token           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  id                     :bigint(8)        not null, primary key
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_id          :bigint(8)
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
