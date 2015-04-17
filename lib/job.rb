require_relative "display"

class Job
  attr_reader :id, :spawn_turn, :cost

  def initialize(job)
    @id     = job.id
    @cost   = job.memory_required
    @spawn_turn   = job.turn
    @turns_needed = job.turns_required
  end

  def process
    @turns_needed -= 1
  end

  def complete?
    @turns_needed == 0
  end
end
