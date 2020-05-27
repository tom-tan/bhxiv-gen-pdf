require 'sinatra'
require 'slim'

class BHXIV < Sinatra::Base
  get '/' do
    slim :index
  end
end
