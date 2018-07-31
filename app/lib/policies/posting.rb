module Policies
  module Posting
    class PublicView
      include ActiveModel::Model

      attr_accessor :post

      def allowed?
        post.published? && post.visible_public?
      end
    end
  end
end