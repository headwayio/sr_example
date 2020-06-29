require 'rails_helper'

RSpec.describe AttachmentDashboard do
  it_behaves_like 'dashboard_attributes' do
    let(:attribute_types) {  %w(attachable id attachment_data created_at updated_at) }
    let(:collection_attributes) {  %w(attachable attachment_data created_at) }
    let(:show_page_attributes) {  %w(id attachable attachment_data created_at updated_at) }
    let(:form_attributes) {  %w(attachable attachment_data) }
  end
end
