require 'rails_helper'

RSpec.describe AuthenticationTokenDashboard do
  it_behaves_like 'dashboard_attributes' do
    let(:attribute_types) { %w(user id body last_used_at ip_address user_agent created_at updated_at) }
    let(:collection_attributes) { %w(id user last_used_at) }
    let(:show_page_attributes) { %w(id user last_used_at ip_address user_agent created_at updated_at) }
    let(:form_attributes) {  %w() }
  end
end
