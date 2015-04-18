require_relative "dialogue_manager"
require_relative "input_manager"
require_relative "display"
require_relative "game"


class GameManager
  attr_reader :game

  def begin
    DialogueManager.start_dialogue
  end

  def start_game
    @game = Game.new
    game.next_turn
    play_turn
  end

  def game_over
    Display.game_over
  end

  def play_turn(skip_turn_display = false)
    game_over if game.over?
    Display.turn_display(game) unless skip_turn_display
    Display.enter_command
    handle_commands(gets.strip)
  end

  def handle_commands(user_input)
    commands = user_input.split
    case commands.first
    when "delete"   then delete_machine
    when "new"      then new_machine
    when "assign"   then assign_job
    when "help"     then help_command
    when "view"     then play_turn
    when "next"     then next_turn
    else
      Display.invalid_command
      play_turn(true)
    end
  end

  def next_turn
    game.next_turn
    play_turn
  end

  def assign_job
    job_id = ask_job_number
    job    = game.find_job(job_id)
    if job
      machine_id  = ask_machine_number
      machine     = game.find_machine(machine_id)
      if machine
        machine.has_job?(job) ? already_assigned : game.assign_job(machine, job)
        play_turn(true)
      else
        invalid_machine_number
      end
    else
      invalid_job_number
    end
  end

  def delete_machine
    machine_id  = ask_machine_number
    machine     = game.find_machine(machine_id)
    if machine
      game.delete_machine(machine)
      play_turn(true)
    else
      invalid_machine_number
    end
  end

  def invalid_machine_number
    Display.invalid_number("machine")
    play_turn(true)
  end

  def invalid_job_number
    Display.invalid_number("job")
    play_turn(true)
  end

  def already_assigned
    Display.already_assigned
    play_turn(true)
  end

  def new_machine
    game.add_machine
    Display.machine_created(game.machines.last)
    play_turn
  end

  def help_command
    Display.help
    play_turn(true)
  end

  def ask_machine_number
    Display.machine_number
    gets.strip.to_i
  end

  def ask_job_number
    Display.job_number
    gets.strip.to_i
  end
end
