RSpec.shared_examples 'dashboard_attributes' do
  it 'has attribute types' do
    attribute_types.each do |attribute|
      expect(subject.attribute_types[attribute.to_sym]).to_not be_nil
    end
  end

  it 'has collection attributes' do
    collection_attributes.each do |attribute|
      expect(subject.collection_attributes).to include(attribute.to_sym)
    end
  end

  it 'has show page attributes' do
    show_page_attributes.each do |attribute|
      expect(subject.show_page_attributes).to include(attribute.to_sym)
    end
  end

  it 'has form attributes' do
    form_attributes.each do |attribute|
      expect(subject.form_attributes).to include(attribute.to_sym)
    end
  end
end
