class PollsController < ApplicationController
  before_filter :load_poll!, :only => [:create_vote, :results, :show, :vote, :router]

  def landing
    if params[:slug]
      # /?slug=foobar ... the landing page redirects here on submit if JavaScript is disabled
      redirect_to polls_path(params[:slug])
    end
    @poll = Poll.new
  end

  def create
    poll = Poll.create params_for_create
    redirect_to polls_url
  end

  def router
    if poll_already_exists 
      if user_already_voted
        show
      else
        vote
      end
    else
      new
    end
  end

  def new
    @poll = Poll.new slug: params[:slug]
    1.times { @poll.options.build }
    render template: 'polls/new'
  end

  def create_vote
    if params[:poll] || params[:options]
      @poll.params = params.merge({session_id: create_or_return_uniq_id})
      @poll.voting_style.to_sym == :sort ? @poll.save_votes_with_score : @poll.save_votes
      session[params[:slug]] = true if !@poll.errors.any?
    end
    redirect_to polls_url
  end

  # Don't require voting to show results
  def results
    show
  end

  def show
   render template: 'polls/results' 
  end

  def vote
    render template: 'polls/vote'
  end

  def slug_is_available
    render text: !poll_already_exists 
  end

  def slug_is_valid
    render text: Poll.new(slug: params[:slug]).valid?
  end
private
  def poll_already_exists
    Poll.where(slug: params[:slug]).any?
  end

  def user_already_voted
    session[params[:slug]]
  end

  def params_for_create
    params.require(:poll).permit(:slug, :question, :voting_style, options_attributes: [:text] )
  end
end
