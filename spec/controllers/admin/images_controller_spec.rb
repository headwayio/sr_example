require 'rails_helper'

RSpec.describe Admin::ImagesController, type: :request do
  it_behaves_like 'dashboard' do
    let(:path) { admin_addresses_path }
  end
end
