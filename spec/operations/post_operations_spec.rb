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
        create(:post, :with_images, images_count: 3)
      }
      subject {PostEdit.new(id: orig.id).call.result}
      it "should create new draft" do
        expect {subject}.not_to raise_error
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
      subject {PostEdit.new(id: orig.id).call.result}
      it "should use post as draft" do
        expect {subject}.not_to raise_error
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
      subject {PostEdit.new(id: orig.id).call.result}
      it "should use existed post as draft" do
        expect {subject}.not_to raise_error
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
    before(:context) {
      create_list(:post, 2)
      create_list(:private_post, 2)
      create_list(:hidden_post, 4)
      create_list(:draft, 5)
      PostEdit.new(id: create(:post).id).call
    }
    describe "if show parameter is 'public'" do
      subject {PostSelect.for_filter(show: 'public').call.result}
      it "should get only public posts" do
        expect(subject).to have(3).items
        expect(subject).to all(have_attributes(status: 'published'))
      end
    end
    describe "if show parameter is 'drafts'" do
      subject {PostSelect.for_filter(show: 'drafts').call.result}
      it "should select drafts" do
        expect(subject).to have(6).items
      end
    end
    describe "if show parameter is 'hidden'" do
      subject {PostSelect.for_filter(show: 'hidden').call.result}
      it "should select hidden" do
        expect(subject).to have(4).items
      end
    end
    describe "if show parameter is 'visible'" do
      subject {PostSelect.for_filter(show: 'visible').call.result}
      it "should select visible posts" do
        expect(subject).to have(9).items
      end
    end
    describe "if show parameter is empty" do
      subject {PostSelect.for_filter({}).call.result}
      it "should select all independend posts (not temporal drafts of posts under editing" do
        expect(subject).to have(14).items
      end
    end
  end

  describe "PostUpdate" do
    describe "update post attributes" do
      let(:cover) {create(:image)}
      let(:target) {create(:draft,
                           title: 'old title',
                           visability_mode: 'visible_public',
                           source_type: 'html',
                           cover_id: nil,
      )
      }
      subject {PostUpdate.new(id: target.id)}
      it "should update attributes" do
        subject.post_attributes = {
          title: 'New title',
          visability_mode: 'visible_private',
          source_type: 'markdown',
          cover_id: cover.id
        }
        subject.call
        target.reload
        expect(target.title).to eq('New title')
        expect(target.visability_mode).to eq('visible_private')
        expect(target.source_type).to eq('markdown')
        expect(target.cover_id).to eq(cover.id)
      end
    end

    describe "update post images" do
      describe "if no images" do
        let(:target) {
          create(:draft)
        }
        let(:images) {
          create_list(:image, 3).map {|i|
            {
              image_id: i.id,
              link: "link_#{i.id}"
            }
          }
        }
        let(:operation) {
          PostUpdate.new(id: target.id, images: images)
        }
        it "should add 3 images" do
          operation.call
          target.reload
          expect(target.images).to have(3).items
        end
      end
      describe "if has images to delete" do
        let(:target) {
          create(:post, :with_images)
        }
        let(:images_new) {
          images_to_update = target.images.map{|i|i.id}[0,2]
          images_to_add = create_list(:image, 2).map{|i|i.id}

          images_to_update.concat(images_to_add).map {|i|
            {
              image_id: i,
              link: "link_#{i}"
            }
          }
        }
        let(:operation) {
          PostUpdate.new(id: target.id, images: images_new)
        }
        it "should remove 1 image and add 2 images" do
          operation.call
          target.reload
          expect(target.images).to have(4).items
        end
      end
      describe "delete all images" do
        let(:target) {
          create(:post, :with_images)
        }
        before { PostUpdate.new(id: target.id, images: []).call }
        it "no images should be left" do
          target.reload
          expect(target.images).to be_empty
        end
      end
    end
  end
end