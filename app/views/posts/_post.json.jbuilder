json.extract! post, :id, :title, :created_at, :updated_at
json.body sanitize_action_text_content(post.body.body)
json.url post_url(post, format: :json)
