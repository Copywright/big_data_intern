require 'pry'
class Job
  attr_reader :id, :spawn_turn, :cost, :turns_needed

  def initialize(job)
    @id     = job.id
    @cost   = job.memory_required
    @spawn_turn   = job.turn
    @turns_needed = job.turns_required
    @assigned     = false
    @queued       = false
  end

  def process
    @turns_needed -= 1
    @assigned = true
  end

  def queue
    @queued = true
  end

  def complete?
    @turns_needed == 0
  end

  def assigned?
    @assigned
  end

  def queued?
    @queued
  end

  def pending?
    assigned? == false && queued? == false
  end
end
