require_relative "game_api_service"

class Machine
  attr_reader :id, :cost, :game_id, :jobs, :queue

  def initialize(id, game_id, terminated)
    @id         = id
    @game_id    = game_id
    @terminated = terminated
    set_properties
  end

  def process
    process_jobs
    process_queue
  end

  def assign_job(job)
    @jobs << job
  end

  def available_memory
    memory_in_use - 64
  end

  def terminated?
    terminated
  end

  def queue_job(job)
    @queue << job
  end

  private

  def set_properties
    @cost     = 1
    @jobs     = []
    @queue    = []
    @processed_jobs = []
  end

  def memory_in_use
    jobs.reduce(0) { |total, job| total + job.cost }
  end

  def can_process?(job)
    job.cost <= available_memory
  end

  def process_jobs
    jobs.each { |j| j.complete? ? @jobs.delete(j) : execute_job(j) }
  end

  def execute_job(job)
    job.process
    @processed_jobs << job
  end

  def process_queue
    queue.each do |j|
      if j.cost <= available_memory
        @jobs << j
        @queue.delete(j)
      end
    end
  end
end
