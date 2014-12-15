class StaticPagesController < ApplicationController
  def home
    @totalwords = 4
    @weakpassword = 'Tr0ub4dor&3'
    @weakpassword_strength = calculate_strength @weakpassword
    @counter = Password.first
    @strongpassword = generate_password
    @strongpassword_strength = calculate_strength @strongpassword
    current_selections
  end

  private

    def current_selections
      session[:capital_selection] = params[:random_capital]
      session[:number_selection] = params[:random_number]
      session[:punctuation_selection] = params[:punctuation]
    end

    def generate_password
      words = Word.all.shuffle.take(@totalwords).collect{ |w| w.word.downcase }
      random_capital words if params[:random_capital] == '1'
      random_number words if params[:random_number] == '1'
      words = join_words words
      compare_strength words
    end

    def compare_strength password
      if calculate_strength(password) <= (@weakpassword_strength * 1.1)
        generate_password
      else
        increment_counter
        password
      end
    end

    def increment_counter
      @counter.count += 1
      @counter.save
    end

    def join_words words
      if params[:punctuation] != nil
        words.join("#{params[:punctuation]}")
      else
        words.join(' ')
      end
    end

    def random_capital words
      pick_one_word = rand(@totalwords)
      words[pick_one_word][0] =
           words[pick_one_word][0].upcase
    end

    def random_number words
      pick_one_word = rand(@totalwords)
      words[pick_one_word] <<
            numbers[rand(0..9)]
    end

    def numbers
      '0123456789'
    end

    def lowercase
      'abcdefghijklmnopqrstuvwxyz'
    end

    def uppercase
      'ABCDEFGHIJKLMNOPQRSTUVWXY'
    end

    def punctuation
     " `~!@#$%^&-_=+[{]}."
    end

    def calculate_strength password
      strength = 0
      strength += 10 if is_character_present numbers, password
      strength += 26 if is_character_present lowercase, password
      strength += 26 if is_character_present uppercase, password
      strength += 19 if is_character_present punctuation, password
      return strength * password.length
    end

    def is_character_present string_to_check, password
      password.each_char do |c|
        return true if string_to_check.include? c
      end
      return false
    end
end
