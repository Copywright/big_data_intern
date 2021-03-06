require 'faraday'
require 'json'
require 'ostruct'
require 'pry'

require_relative "machine"

class GameAPIService
  attr_reader :game_id

  def initialize
    @game_id = new_game["id"]
  end

  def game_url
    "/games/#{game_id}"
  end

  def conn
    Faraday.new(url: 'http://job-queue-dev.elasticbeanstalk.com')
  end

  def current_game
    response  = conn.get "#{game_url}"
    json      = JSON.parse(response.body)
    OpenStruct.new(json)
  end

  def new_game
    response  = conn.post '/games'
    json      = JSON.parse(response.body)
    OpenStruct.new(json)
  end

  def new_machine
    response  = conn.post  "#{game_url}/machines"
    json      = JSON.parse(response.body)
    machine   = OpenStruct.new(json)
    Machine.new(machine.id, machine.game_id, machine.terminated)
  end

  def delete_machine(id)
    response  = conn.post  "#{game_url}/machines/#{id}"
    json      = JSON.parse(response.body)
  end

  def assign_job_to_machine(machine_id, job_id)
    conn.post do |request|
      request.url "#{game_url}/machines/"
      request.body = %Q{ job_ids: "[#{job_id}]" }
    end
  end

  def next_turn
    response = conn.get   "#{game_url}/next_turn"
    json = JSON.parse(response.body)
    OpenStruct.new(json)
  end
end
