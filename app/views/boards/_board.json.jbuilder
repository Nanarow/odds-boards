json.extract! board, :id, :title, :body, :status, :upvotes_count, :views_count, :last_activity_at, :created_at, :updated_at

json.author board.author
json.category board.category
json.tags board.tags
json.comments board.comments

json.url board_url(board, format: :json)
