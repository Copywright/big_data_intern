require_relative "game_api_service"
require_relative "display"
require_relative "job"

class Game
  attr_reader :service, :jobs, :machines, :completed_jobs, :total_cost, :delay_turns

  def initialize
    @service = GameAPIService.new
    set_properties
  end

  def add_machine
    machine     = service.new_machine
    @machines   << machine
    @total_cost += machine.cost
  end

  def assign_job(machine, job)
    service.assign_job_to_machine(machine.id, job.id)
    if machine.can_process?(job)
      machine.assign_job(job)
      Display.job_assigned(job, machine)
    else
      machine.queue_job(job)
      Display.job_queued(job, machine)
    end
  end

  def delete_machine(machine)
    service.delete_machine(machine.id)
    @machines.reject! { |m| m.id == machine.id }
    @completed_jobs += machine.completed_jobs unless machine.completed_jobs.empty?
  end

  def find_machine(machine_id)
    machines.find { |m| m.id == machine_id }
  end

  def find_job(job_id)
    jobs.find { |j| j.id == job_id }
  end

  def current_turn
    service.current_game.current_turn
  end

  def over?
    service.current_game.completed || current_turn == 50
  end

  def next_turn
    process_machines
    check_delay_turns
    turn = service.next_turn
    add_jobs(turn)
  end

  private

  def set_properties
    @jobs           = []
    @machines       = []
    @total_cost     = 0
    @delay_turns    = 0
  end

  def check_delay_turns
    jobs.each do |j|
      @delay_turns += 1 if j.spawn_turn < current_turn && j.pending?
    end
  end

  def process_machines
    machines.each { |m| m.process }
  end

  def add_jobs(turn)
    jobs_data = turn.jobs.map { |j| OpenStruct.new(j) }
    jobs      = jobs_data.map { |j| Job.new(j) }
    @jobs += jobs
  end
end
