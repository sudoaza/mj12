class WelcomeController < ApplicationController
  def index
    @entity = Entity.new
    @link = Link.new
  end
end
