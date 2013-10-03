class TextsController < ApplicationController
  def index
    @texts = Text.all
  end

  def conversation
    @texts = Text.where('name=?', params[:name])
    render 'index'
  end
end
