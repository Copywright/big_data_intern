require 'pry'
require_relative "game_api_service"
require_relative "display"
require_relative "job"

class Game
  attr_reader :service, :jobs, :machines, :completed_jobs

  def initialize
    @service        = GameAPIService.new
    @jobs           = []
    @machines       = []
    @completed_jobs = []
  end

  def add_machine
    @machines << service.new_machine
  end

  def delete_machine(id)
    service.delete_machine(id)
    @machines.reject! { |m| m.id == id }
  end

  def next_turn
    turn = service.next_turn
    process_machines
    add_jobs(turn)
  end

  def process_machines
    machines.each { |m| m.process }
  end

  def add_jobs(turn)
    jobs_data = turn.jobs.map { |j| OpenStruct.new(j) }
    jobs      = jobs_data.map { |j| Job.new{j} }
    jobs.each { |j| @jobs << j }
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

  def current_turn
    service.current_game.current_turn
  end

  def completed?
    service.current_game.completed
  end
end
