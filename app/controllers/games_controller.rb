require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @answer = params[:answer]
    @grid = params[:grid]
    @message = ''
    if !valid_word?
      @message = "Sorry but #{@answer.upcase} does not seem to be a valid English word..."
    elsif !in_grid?
      @message = "Sorry but #{@answer.upcase} can't be built out of #{@grid}"
    else
      @message = "Congratulations! #{@answer.upcase} is a valid English word!"
    end
  end

  private

  def valid_word?
    heroku_url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    response = URI.open(heroku_url)
    JSON.parse(response.read.to_s)['found']
  end

  def in_grid?
    @answer.chars.all? { |c| @grid.include? c }
    @answer.chars.all? { |c| @answer.count(c) <= @grid.count(c) }
  end
end
