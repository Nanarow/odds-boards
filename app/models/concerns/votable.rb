module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote(voter)
    set_vote(voter, true)
  end

  def downvote(voter)
    set_vote(voter, false)
  end

  def unvote(voter)
    if vote = votes.find_by(voter: voter)
      vote.destroy
      true
    else
      false
    end
  end

  def vote_count
    votes.where(is_upvote: true).count - votes.where(is_upvote: false).count
  end

  private

  def set_vote(voter, is_upvote)
    vote = votes.find_or_initialize_by(voter: voter)
    unless vote.is_upvote == is_upvote
      vote.is_upvote = is_upvote
      vote.save
    end
    true
  end
end
