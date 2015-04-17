require_relative "job_queue_service"

class Machine
  attr_reader :id, :cost, :memory, :game_id, :jobs, :queue

  def initialize(id, game_id, terminated)
    @id         = id
    @game_id    = game_id
    @terminated = terminated
    set_constants
  end

  def set_constants
    @cost     = 1
    @memory   = 64
    @jobs     = []
    @queue    = []
  end

  def assign_job(job, service)
    jobs << job
    service.assign_job_to_machine(id, job.id)
  end

  def

  def terminated?
    terminated
  end

end
