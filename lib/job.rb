class Job
  attr_reader :id, :spawn_turn, :cost, :turns_needed

  def initialize(job)
    @id     = job.id
    @cost   = job.memory_required
    @spawn_turn   = job.turn
    @turns_needed = job.turns_required
    @assigned     = false
  end

  def process
    @turns_needed -= 1
    @assigned = true
  end

  def complete?
    @turns_needed == 0
  end

  def pending?
    !@assigned
  end
end
