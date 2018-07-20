require 'rails_helper'

Dir[Rails.root.join("app/operations/**/*.rb")].each {|f| require f}

include Operations::PostOperations

RSpec.describe 'PostOperations', type: :model do
  describe "PostCreate" do
    subject {PostCreate.new.call.result}
    it 'should create empty draft' do
      expect {subject}.not_to raise_error
      expect(subject).to_not be_nil
      expect(subject.status).to eq('draft')
      expect(subject.source_type).to eq('markdown')
      expect(subject.visability_mode).to eq('hidden')
      expect(subject.body_source).not_to be_nil
    end
  end

  describe "PostEdit" do
    describe "New draft for already published post" do
      let(:orig) {
        create(:post, :with_images, images_count: 3 )
      }
      subject {PostEdit.new(id: orig.id).call.result}
      it "should create new draft" do
        expect { subject }.not_to raise_error
        expect(subject.original_post).to eq(orig)
        expect(subject.title).to eq(orig.title)
        expect(subject.status).to eq('draft')
        expect(subject.visability_mode).to eq('visible_public')
        expect(subject.body_source).not_to be_nil
        expect(subject.image_links).to have(3).items
      end
    end

    describe "Open non published post draft" do
      let(:orig) {
        create(:draft)
      }
      subject { PostEdit.new(id: orig.id).call.result }
      it "should use post as draft" do
        expect { subject }.not_to raise_error
        expect(subject).to eql(orig)
      end
      it "should have props, copied from origin" do
        expect(subject.title).to eq(orig.title)
        expect(subject.status).to eq('draft')
        expect(subject.visability_mode).to eq('hidden')
        expect(subject.body_source).not_to be_nil
      end
    end

    describe "Open already craeted draft" do
      let(:orig) {
        create(:public_post)
      }
      let(:prev_draft) {
        PostEdit.new(id: orig.id).call.result
      }
      subject { PostEdit.new(id: orig.id).call.result }
      it "should use existed post as draft" do
        expect { subject }.not_to raise_error
        is_expected.to eql(prev_draft)
      end
      it "should have props, copied from origin" do
        expect(subject.title).to eq(orig.title)
        expect(subject.status).to eq('draft')
        expect(subject.visability_mode).to eq('visible_public')
        expect(subject.body_source).not_to be_nil
      end
    end
  end

  describe "PostSelect" do
    before(:suite) {
      create_list(:post, 3)
      create_list(:private_post, 2)
      create_list(:hidden_post, 4)
      create_list(:draft, 5)
    }
    describe "should select public posts" do
      subject { PostSelect.for_filter(show: 'public')}
      it "should get only public posts" do
        is_expected.to have(3).items
      end
    end
  end

end