require "pry"

class InputManager

  def self.parse(input)
    case
    when input.downcase == "y" then return true
    when input.downcase == "n" then return false
    else return "invalid"
    end
  end

  def self.check_input
    user_input = gets.chomp
    parse(user_input)
  end
end
