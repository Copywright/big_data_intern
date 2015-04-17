require_relative "display"
require_relative "input_manager"

class DialogueManager

  def self.start_dialogue
    new.start_dialogue
  end

  def start_dialogue
    Display.intro_sequence
    response = InputManager.check_input
    initial_tree(response)
  end

  def initial_tree(input_response)
    invalid_dialogue if input_response == "invalid"
    input_response ? game_start_dialogue : exit_dialogue
  end

  def repeat_directions
    Display.sweeven_retort
    response = InputManager.check_input
    response ? game_start_dialogue(true) : Display.sweeven_dump_off
  end

  def game_start_dialogue(skip_hr = false)
    Display.hr_dump_off unless skip_hr
    Display.directions
    response = InputManager.check_input
    response ? escape_dialogue : repeat_directions
  end

  def invalid_dialogue
    Display.hr_invalid
    response = InputManager.check_input
    response ? game_start_dialogue : exit_dialogue
  end

  def exit_dialogue
    Display.hr_retort
    response = InputManager.check_input
    response ? Display.hr_gtfo : game_start_dialogue
  end

  def escape_dialogue
    Display.sweeven_dump_off
    GameManager.start_game
  end
end
