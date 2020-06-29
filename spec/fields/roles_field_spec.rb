require 'rails_helper'

describe RolesField, type: :field do
  describe '#to_s' do
    let(:field) do
      RolesField.new('attribute', %w[data1 data2], 'page')
    end

    subject(:roles_field_to_s) { field.to_s }

    it 'returns data concatenated' do
      expect(roles_field_to_s).to eq('data1, data2')
    end
  end
end
