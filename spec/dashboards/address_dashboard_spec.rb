require 'rails_helper'

RSpec.describe AddressDashboard do
  it_behaves_like 'dashboard_attributes' do
    let(:attribute_types) { %w(addressable id city line1 line2 state zip created_at updated_at) }
    let(:collection_attributes) { %w(id addressable line1 city state) }
    let(:show_page_attributes) { %w(id addressable line1 line2 city state zip created_at updated_at) }
    let(:form_attributes) { %w(addressable line1 line2 city state zip) }
  end
end
