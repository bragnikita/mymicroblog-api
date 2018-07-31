module Operations
  module ImageOperations
    class ImageUpload < Operations::OperationBase
      def initialize(file)
        self.file = file
      end
      attr_accessor :file

      def doWork
        Image.create!(link: file)
      end
    end

    class ImageUploadForPost < Operations::OperationBase
      attr_accessor :post_id, :link, :file

      def doWork
        post = Post.find(post_id)
        image = Image.create!(link: file)
        link_name = link
        if link_name.blank?
          link_name = image.id.to_s
        end
        image_of_post = ImageOfPost.new(link_name: link_name, image: image)
        post.image_links << image_of_post
        post.save!
        image
      end
    end

  end
end