require 'json'
require 'open-uri'

class GamesController < ApplicationController
  @@sum = 0

  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a[rand(10)] }
  end

  def score
    result = {}
    grid = params[:letters] # hidden field tag or create global variable
    word = params[:word]
    score_and_message = score_and_message(word, grid)
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    @result = result
  end

  def score_and_message(word, grid)
    if compare_arrays?(word, grid)
      if english_word?(word)
        @@sum += word.length
        score = @@sum
        [score, "congratulations! #{word.upcase} is an English word"]
      else
        [0, "#{word.upcase} is not an english word"]
      end
    else
      [0, "#{word.upcase} is not in the grid"]
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compare_arrays?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end
end
