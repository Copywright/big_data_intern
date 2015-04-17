require_relative "display"
require_relative "dialogue_manager"
require_relative "input_manager"

class GameManager
  def initialize
  end

  def self.start_game
  end

  def self.begin
    DialogueManager.start_dialogue
  end
end
