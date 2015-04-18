require_relative "game_api_service"
require_relative "display"

class Machine
  attr_reader :id, :cost, :game_id, :jobs, :queue, :processed_jobs, :completed_jobs

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

  def has_job?(job)
    jobs.find {|j| j.id == job.id }
  end

  def available_memory
    64 - memory_in_use
  end

  def terminated?
    terminated
  end

  def queue_job(job)
    @queue << job
  end

  def can_process?(job)
    job.cost <= available_memory
  end

  private

  def set_properties
    @cost     = 1
    @jobs     = []
    @queue    = []
    @completed_jobs = []
  end

  def memory_in_use
    jobs.reduce(0) { |total, job| total + job.cost }
  end

  def process_jobs
    jobs.each { |j| j.complete? ? @jobs.delete(j) : execute_job(j) }
    complete_jobs = jobs.find_all {|j| j.complete? }
    complete_jobs.each {|j| complete_job(job) }
  end

  def complete_job(job)
    @jobs.delete(job)
    @completed_jobs << job
  end

  def execute_job(job)
    job.process
    Display.job_complete(job) if job.complete?
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
