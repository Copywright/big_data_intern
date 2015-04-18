require "colorize"

class Display

  def self.intro_sequence
    intro_banner
    hr_intro
  end

  def self.turn_display(game)
    console_border
    puts "Turn: #{game.current_turn}\n".red
    puts "Delay Turns: #{game.delay_turns}\n".red
    puts "Total Cost: $#{game.total_cost}\n".red
    job_list(game.jobs)
    machine_list(game.machines)
  end

  def self.job_list(jobs)
    puts "Jobs:   \n".green
    jobs.each_with_index do |j, i|
      puts "      #{i + 1}. Job ##{j.id} | Cost: #{j.cost}GB | Turns To Completion: #{j.turns_needed} | In Progress: #{!j.pending?} #{"\n" if i == jobs.length - 1}".yellow
    end
  end

  def self.machine_list(machines)
    puts "Machines:   #{"None\n" if machines.empty?}".green
    puts
    machines.each_with_index do |m, i|
      puts "\n      #{i + 1}. Machine ##{m.id} | #{m.available_memory}GB/64GB remaining\n".red
      puts "          Current Jobs: #{"None" if m.jobs.empty?}".yellow
      m.jobs.each_with_index do |j, i|
        puts "            #{i + 1}. Job ##{j.id} | Cost: #{j.cost}GB | Turns To Completion: #{j.turns_needed} #{"\n" if m.jobs.last == j}".yellow
      end
      puts "          Queued Jobs: #{" None" if m.queue.empty?}".yellow
      m.queue.each_with_index do |j, i|
        puts "            #{i + 1}. Job ##{j.id} | Cost: #{j.cost}GB | Turns To Completion: #{j.turns_needed} #{"\n" if m.queue.last == j}".yellow
      end
    end
  end

  def self.job_assigned(machine, job)
    puts "Job ##{job.id} assigned to Machine ##{machine.id}\n".red
  end

  def self.already_assigned
    puts "Job is already assigned to that machine.\n".red
  end

  def self.job_complete(job)
    puts "Job ##{job.id} is complete!".green
  end

  def self.job_queued(machine, job)
    puts "Machine ##{machine.id} has insufficient space, Job ##{job.id} placed into the machine's queue.".red
  end

  def self.directions
    puts sweeven + "You'll be in charge of executing the jobs the real programmers are
        queuing up. Take these directions.\n".yellow
    help
    puts sweeven + "Do you understand?\n".yellow
    indicate_input
  end

  def self.sweeven_dump_off
    puts "\n" + sweeven + "Good. Now, I'm off to leave vague passive aggressive code review comments.
        Do a good job and I've got a COBOL sticker with your name on it!".yellow
  end

  def self.sweeven_retort
    puts "\n" + sweeven + "I have no time for this, do you need to go through this quickly
        once more?\n".yellow
    indicate_input
  end

  def self.hr_retort
    puts [
      pissed_hr + "Well, you've already signed the contract! You really want to
                                    go back on your word?\n".yellow,
      pissed_hr + "Uhhhmmm, we already have you in our system and payroll....
                                    Do you really wanna cause so much trouble?\n".yellow,
      pissed_hr + "You sure that's how you want to play it? Wouldn't wanna end up
                                    on a secret blacklist somewhere, would you?\n".yellow
    ].sample
    indicate_input
  end

  def self.machine_number
    print "Machine #? > ".red
  end

  def self.job_number
    print "Job #? > ".red
  end

  def self.machine_deleted(machine)
    puts "Machine ##{machine.id} has been deleted.\n".red
  end

  def self.machine_created(machine)
    puts "Machine ##{machine.id} has been created.\n".red
  end

  def self.game_over
    puts "And so, your career in the software industry irreparably and unceremoniously
    came to an end.".red.on_black.blink
  end

  def self.hr_dump_off
    puts happy_hr + "Awesomeee! This is one of our lead developers,
                  Sweeven. He'll get you started today.\n".yellow
    puts sweeven  + "Alright Mr. No-CS-Degree, since you wormed your in here,
         we'll put you on grunt work til yer singing
         fibonacci numbers and can do Fizzbuzz in less than 5 lines.\n".yellow
  end

  def self.hr_invalid
    puts happy_hr + "Err, I'm sorry, come again? Are you ready to
                  get working today?".yellow
    indicate_input
  end

  def self.hr_gtfo
    puts pissed_hr + "Okay then, please exit the premises, you useless waste of
                                    referral money.\n\n".red
    game_over
    end

  def self.hr_intro
    puts happy_hr + "Hey there, we're really glad to have you!
                  You'll love it here! Ready to get started?\n".yellow
    indicate_input
  end

  def self.indicate_input
    print "(Y/n) > ".red
  end

  def self.enter_command
    print "\nEnter Command: > ".red
  end

  def self.intro_banner
    puts "[.. [..               [.....                [..            [..           [..
[.    [..  [.         [..   [..             [..            [..           [..
[.     [..      [..   [..    [..   [..    [.[. [.   [..    [..[.. [..  [.[. [.   [..    [. [...[.. [..
[... [.   [.. [..  [..[..    [.. [..  [..   [..   [..  [.. [.. [..  [..  [..   [.   [..  [..    [..  [..
[.     [..[..[..   [..[..    [..[..   [..   [..  [..   [.. [.. [..  [..  [..  [..... [.. [..    [..  [..
[.      [.[.. [..  [..[..   [.. [..   [..   [..  [..   [.. [.. [..  [..  [..  [.         [..    [..  [..
[.... [.. [..     [.. [.....      [.. [...   [..   [.. [...[..[...  [..   [..   [....   [...   [...  [..
               [..
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------\n\n".green.blink
  end

  def self.help
    puts "Welcome to the Job Processor!\n

    Your job as operator is to assign pending jobs to machines to be executed, while
    keeping the number of jobs left idle and server costs as low as possible.\n

    Jobs have a cost in GB per turn and a set number of turns required to complete.
    When a job is given and remains pending, it's recorded as a delay turn. Delay turns
    are tracked at the end of the day.\n
    Machines have 64GB of memory to execute jobs and cost $1 a turn. When a machine is
    full and a job is assigned, it's added to the machine's queue to be executed when sufficient
    space is cleared.\n

    Remember, the main objectives are:\n
            1. Keep number of delay turns as low as possible.
            2. Keep the total cost as low as possible.\n

    These are the commands you will have every turn:

            1.  delete machine
              - Deletes a machine
            2.  new machine
              - Creates a new machine.
            3.  assign job
              - Assigns a job to a machine.
            4.  help
              - Use this command to review these directions.
            5.  view turn
              - Redisplay the current turn display
            6.  next turn\n\n".green
  end

  def self.invalid_number(subject)
    puts "\nInvalid #{subject} number\n".red
  end

  def self.invalid_command
    puts "\nInvalid command.\n".red
  end

  def self.console_border
    puts "\n\n\n≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤≥≤\n\n\n".green.on_red.blink
  end

  def self.happy_hr
    "Friendly HR Lady: ".blue
  end

  def self.pissed_hr
    "Considerably Less Friendly HR Lady: ".blue
  end

  def self.sweeven
    "Sweeven: ".blue
  end

  def self.game_over
    puts "Congrats, you finished with #{game.completed_jobs.count} completed jobs, #{game.delay_turns} delay turns and cost the company #{game.total_cost}.\n\n Thanks for playing!".green.blink
  end
end
