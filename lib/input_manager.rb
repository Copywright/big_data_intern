require "pry"
require_relative "game_manager"

class InputManager

  def self.parse(input)
    case
    when input.downcase == "y" then return true
    when input.downcase == "n" then return false
    else return "invalid"
    end
  end

  def self.check_input
    user_input = gets.strip
    parse(user_input)
  end

  # 1.  delete machine
  #   - Deletes a machine
  # 2.  new machine
  #   - Creates a new machine.
  # 3.  assign job
  #   - Assigns a job to a machine.
  # 4.  help
  #   - Use this command to review these directions.
  # 5.  next turn
end
