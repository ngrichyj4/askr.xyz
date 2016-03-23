class PollsController < ApplicationController
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
        # TODO: view results
      else
        vote
      end
    else
      new
    end
  end

  def new
    @poll = Poll.new slug: params[:slug]
    10.times { @poll.options.build }
    render template: 'polls/new'
  end

  def vote
    @poll = Poll.find_by_slug params[:slug]
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
    false # TODO - do something session-ey for this?
  end

  def params_for_create
    params.require(:poll).permit(:slug, :question, :voting_style, options_attributes: [:text] )
  end
end
