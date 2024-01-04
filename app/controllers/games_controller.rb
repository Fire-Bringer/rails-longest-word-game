require 'open-uri'

class GamesController < ApplicationController

  # Used to display a new random grid and a form
  # Form should be submitted with a POST to the "score" action
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @guess = params[:word]
    @grid = params[:grid]
    @result_message = 'default'

    response = URI.parse("https://wagon-dictionary.herokuapp.com/#{@guess}")
    json = JSON.parse(response.read)
    english_word = json['found'] # True or False

    # If the word can't be built out of the original grid
    unless @guess.chars.all? { |letter| @grid.include?(letter) }
      @result_message = "Sorry, but #{@guess} can't be built out of #{@grid}"
    end

    @result_message = if english_word == false
                        "Sorry, but #{@guess} does not seem to be a valid English word..."
                      else
                        "Congratulations! #{@guess} is a word!"
                      end
  end
end
