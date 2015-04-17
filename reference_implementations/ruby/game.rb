require 'rubygems'
require 'bundler/setup'

require 'json'
require 'rest-client'

host = 'http://job-queue-dev.elasticbeanstalk.com'

#
# Create a new game
#
game_json = RestClient.post(
  "#{host}/games",
  {}
  # { long: true }
).body
game = JSON.parse(game_json)

#
# Create a new machine
#
machine_json = RestClient.post(
  "#{host}/games/#{game['id']}/machines",
  {}
).body
machine = JSON.parse(machine_json)

#
# Pull the data for the next turn. This will include the jobs to be
# scheduled as well as the current status of the game.
#
turn_json = RestClient.get(
  "#{host}/games/#{game['id']}/next_turn"
).body
turn = JSON.parse(turn_json)

status = turn['status']

jobs_found = turn['jobs'].count

#
# When the status changes to completed the game is over
#
while (status != 'completed')
  puts "On turn #{turn['current_turn']}, got #{turn['jobs'].count} jobs, having completed #{turn['jobs_completed']} of #{jobs_found} with #{turn['jobs_running']} jobs running, #{turn['jobs_queued']} jobs queued, and #{turn['machines_running']} machines running"

  #
  # This is purely for showing off how deleting machines works
  #
  if (turn['current_turn'] % 25) == 0
    RestClient.delete("#{host}/games/#{game['id']}/machines/#{machine['id']}")
    machine_json = RestClient.post("#{host}/games/#{game['id']}/machines", {}).body
    machine = JSON.parse(machine_json)
  end

  #
  # Get the ids for all of the jobs in this batch
  #
  job_ids = turn['jobs'].map { |job| job['id'] }

  #
  # If we got any jobs, assign them all to the machine
  #
  if job_ids.any?
    RestClient.post(
      "#{host}/games/#{game['id']}/machines/#{machine['id']}/job_assignments",
      job_ids: JSON.dump(job_ids)
    ).body
  end

  #
  # And then pull the data for the next turn
  #
  turn_json = RestClient.get("#{host}/games/#{game['id']}/next_turn").body
  turn = JSON.parse(turn_json)

  jobs_found += turn['jobs'].count

  status = turn['status']
end

game_json = RestClient.get("#{host}/games/#{game['id']}",).body
puts game_json
puts "\n\n"

completed_game = JSON.parse(game_json);
puts "COMPLETED GAME WITH:"
puts "Total delay: #{completed_game['delay_turns']} turns"
puts "Total cost: $#{completed_game['cost']}"
