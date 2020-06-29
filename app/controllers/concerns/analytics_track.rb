module AnalyticsTrack
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/LineLength
  # Example Traditional Event: analytics_track(user, 'Created Widget', { widget_name: 'foo' })
  # Example Page View:         analytics_track(user, 'Page Viewed', { page_name: 'Terms and Conditions', url: '/terms' })
  #
  # NOTE: setup some defaults that we want to track on every event mixpanel_track
  # NOTE: the identify step happens on every page load to keep intercom.io and mixpanel people up to date
  # rubocop:enable Metrics/LineLength
  def analytics_track(user, event_name, options = {})
    return if user.tester?

    sanitized_options = sanitize_hash_javascript(options)
    segment_attributes = {
      user_id: user.uuid,
      event: event_name,
      properties: {
        **browser_attributes,
        roles: roles_for_user(user),
        rails_env: Rails.env.to_s,
      }.merge(sanitized_options),
    }
    # rubocop:enable

    Analytics.track(segment_attributes)
    logger.debug('Analytics tracking info: ' + segment_attributes.to_s)
  end

  private

  def browser_attributes
    if defined?(browser).present?
      {
        browser: browser&.name,
        browser_id: browser&.id,
        browser_version: browser&.version,
        platform: browser&.platform,
      }
    else
      {
        browser: 'unknown',
        browser_id: 'unknown',
        browser_version: 'unknown',
        platform: 'unknown',
      }
    end
  end

  def roles_for_user(user)
    user.roles.map(&:to_s).join(',')
  rescue StandardError
    ''
  end

  def sanitize_hash_javascript(hash)
    hash.deep_stringify_keys
      .deep_transform_keys { |k| sanitize_javascript(k) }
      .transform_values    { |v| sanitize_javascript(v) }
  end

  def sanitize_javascript(value)
    value.is_a?(String) ? ActionView::Base.new.escape_javascript(value) : value
  end
end
