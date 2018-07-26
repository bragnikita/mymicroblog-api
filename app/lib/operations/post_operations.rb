module Operations
  module PostOperations
    class PostEdit < Operations::OperationBase
      attr_accessor :id

      def doWork
        origin_post = Post.find(id)
        if origin_post.draft?
          draft = origin_post
        else
          draft = Post.find_by(original_post: origin_post)
        end
        if draft.nil?
          draft = Post.new(
            title: origin_post.title,
            excerpt: origin_post.excerpt,
            slug: origin_post.slug,
            status: Post.statuses[:draft],
            source_type: origin_post.source_type,
            visability_mode: origin_post.visability_mode,
            cover_id: origin_post.cover_id,
            original_post: origin_post,
            published_at: origin_post.published_at,
            post_contents: [origin_post.body_source]
          )
          origin_post.image_links.each do |link|
            draft.image_links << ImageOfPost.new(
              link_name: link.link_name,
              image_id: link.image_id
            )
          end
          draft.save!
        end
        draft
      end
    end

    class PostCreate < Operations::OperationBase

      def doWork
        post = Post.new(
          status: Post.statuses[:draft],
          source_type: Post.source_types[:markdown],
          visability_mode: Post.visability_modes[:hidden]
        )
        post.post_contents.build(type: 'body_source')
        Post.today_posts.tap {|posts|
          suffix = posts.empty? ? '' : "-#{posts.size}"
          post.slug = Date.today.strftime("%Y-%m-%d#{suffix}")
        }
        post.save!
        post
      end
    end

    class PostSelect < Operations::SelectorBase
      attr_accessor :order, :filter

      def initialize(attributes = {})
        assign_attributes(attributes) if attributes
        @select_all_drafts = false
        super()
      end

      def self.for_filter(query = {})
        PostSelect.new.set_for_filter(query)
      end

      def set_for_filter(query)
        case query[:show]
          when 'public'
            self.publicPosts
          when 'visible'
            self.visible
          when 'hidden'
            self.hidden
          when 'drafts'
            self.drafts
          else
            @filter = lambda {|q| q.all}
        end
        self
      end

      def publicPosts
        @order = {published_at: :desc}
        @filter = lambda {|q| q.where(status: :published, visability_mode: :visible_public)}
      end

      def drafts
        @select_all_drafts = true
        @filter = lambda {|q|
          q.where(status: :drafts)
        }
      end

      def hidden
        @filter = lambda {|q|
          q.where(status: :published, visability_mode: :hidden)
        }
      end

      def visible
        @order = {published_at: :desc}
        @filter = Proc.new {|q|
          q.where(status: :published)
        }
      end

      def doWork
        if @select_all_drafts
          q = Post
        else
          q = Post.where.not("status = 'draft' and original_post_id IS NOT NULL")
        end
        if @filter
          q = @filter.call(q)
        else
          q = q.all
        end
        if @order
          q.order(@order)
        else
          q.order(updated_at: :desc)
        end
        q
      end
    end

    class PostUpdate < Operations::OperationBase

      attr_accessor :id, :post_attributes, :images, :body

      def doWork
        update_post if post_attributes.present?
        update_images unless images.nil?
        update_content unless body.nil?
        get_post
      end

      def get_post
        @post ||= Post.find(id)
      end

      private

      def update_post
        post = get_post
        post.update(post_attributes)
      end

      def update_images
        new_image_ids = images.map {|i| i[:image_id]}
        images_to_delete = []
        get_post.images.each {|i|
          images_to_delete << i unless new_image_ids.include?(i.id)
        }
        images_to_delete.each {|i| get_post.images.delete(i)}
        old_image_ids = get_post.image_links.map {|i| i.image_id}
        images.each {|i|
          if old_image_ids.include?(i[:image_id])
            update = get_post.image_links.find_by(image_id: i[:image_id])
            update.link_name = i[:link]
          else
            get_post.image_links.build({image_id: i[:image_id], link_name: i[:link]})
          end
        }
        get_post.save!
      end

      def update_content
        get_post.body_source.content = body
        get_post.save!

        res = ""
        if get_post.source_type == 'markdown'
          res = Transformations::Markdown::translate(body)
        else
          res = Transformations::HTML::translate(body)
        end
        body_result = get_post.body_result
        if body_result.nil?
          body_result = get_post.build_body_result
        end
        body_result.content = res
        get_post.save!
      end
    end
  end
end