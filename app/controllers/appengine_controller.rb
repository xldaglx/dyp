class AppengineController < ApplicationController
  def health
    render plain: 'OK'
  end
end