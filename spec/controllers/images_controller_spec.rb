require 'rails_helper'

RSpec.describe ImagesController, type: :request do
  let(:admin_user) { create(:user, :admin) }

  describe '#create' do
    let(:upload) do
      Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/avatar.svg", "image/svg+xml")
    end

    let(:headers) { { "ContentType": "image/svg+xml", 'Accept': 'application/json' } }

    context 'with requests that accept JSON' do
      context 'successfully' do
        let(:params) { { image: { image: upload } } }
        before do
          sign_in(admin_user)
          post images_path, params: params, headers: headers
        end

        it 'returns 200 status' do
          expect_status 200
        end

        it 'responds with the image url' do
          expect(JSON.parse(response.body)['url']).to eq(Image.last.image_url)
        end
      end

      context 'unsuccessfully' do
        let(:params) { { image: { image: upload } } }

        before do
          sign_in(admin_user)
        end

        describe 'accepting html' do
          let(:headers) { { "ContentType": "image/svg+xml", 'Accept': 'text/html' } }
          it 'returns 302 status' do
            allow_any_instance_of(Image).to receive(:save).and_return(false)
            post images_path, params: params, headers: headers
            expect_status 302
          end
        end

        describe 'accepting json' do
          let(:headers) { { "ContentType": "image/svg+xml", 'Accept': 'application/json' } }

          it 'returns 422 status' do
            allow_any_instance_of(Image).to receive(:save).and_return(false)
            post images_path, params: params, headers: headers
            expect_status 422
          end

          it 'returns some errors' do
            allow_any_instance_of(Image).to receive(:save).and_return(false)
            allow_any_instance_of(Image).to receive(:errors).and_return( { error: "Something went wrong" } )
            post images_path, params: params, headers: headers
            expect(JSON.parse(response.body)["error"]).to eq 'Something went wrong'
          end
        end
      end
    end
  end
end
