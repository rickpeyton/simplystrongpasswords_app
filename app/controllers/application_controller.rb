class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hello
    password = Word.all.shuffle.take(3).collect{ |w| w.word }.join(' ')
    render text: "#{password}"
  end
end
