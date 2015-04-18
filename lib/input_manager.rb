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
end
