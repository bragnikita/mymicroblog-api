module Operations
  module PostOperations
    class PostEdit < Operations::OperationBase
      include ActiveModel::Model

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

      def self.for_filter(query)
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
            @filter = Proc.new {|q| q.all}
        end
      end

      def publicPosts
        @order = {published_at: :desc}
        @filter = Proc.new {|q|
          q.where(status: :published, visability_mode: :visible_public)
        }
      end

      def drafts
        @filter = Proc.new {|q|
          q.where(status: :drafts)
        }
      end

      def hidden
        @filter = Proc.new {|q|
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
        q = Post
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
  end
end