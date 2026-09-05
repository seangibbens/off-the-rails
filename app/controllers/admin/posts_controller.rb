module Admin
  class PostsController < BaseController
    def destroy
      post = Post.find(params.expect(:id))
      title = post.title.presence || "Untitled post"
      post.destroy!

      redirect_to admin_root_path, notice: "#{title} was deleted.", status: :see_other
    end
  end
end
