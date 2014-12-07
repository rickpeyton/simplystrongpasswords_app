class StaticPagesController < ApplicationController
  def home
    @weakpassword = 'Tr0ub4dor&3'
    @weakpassword_strength = calculate_strength @weakpassword
    @strongpassword = generate_password
    @strongpassword_strength = calculate_strength @strongpassword
  end

  private

    def generate_password
      Word.all.shuffle.take(3).collect{ |w| w.word.capitalize }.join(' ')
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
