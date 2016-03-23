class PollsController < ApplicationController
  def landing
    @poll = Poll.new
  end

  def router
    create
  end

  def create
    @poll = Poll.create slug: params[:slug]
    render template: 'polls/create'
  end
end
