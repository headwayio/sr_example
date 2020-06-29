require 'rails_helper'
require Rails.root.join('lib', 'seeder')

RSpec.describe Seeder do
  describe '#users' do
    before do
      Seeder.users
    end

    it 'creates 11 users' do
      expect(User.all.count).to eq 11
    end

    it 'creates a single admin' do
      expect(User.where(roles_mask: 1).count).to eq 1
    end

    it 'creates 10 users' do
      expect(User.where(roles_mask: nil).count).to eq 10
    end
  end
end
