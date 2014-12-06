class StaticPagesController < ApplicationController
  def home
    @password = Word.all.shuffle.take(3).collect{ |w| w.word }.join(' ')
  end
end
