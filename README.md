# Custora's Job Queue Game #

At Custora, we process a lot of data, calculating complex statistics from it as we go.
Those statistics need to be calculated on demand, coming in an irregular pattern as users
access the site, and they are also very heavy computations that can sometimes take a long
time to compute.

To handle this system, we have a job queue that can add and remove machines dynamically
based on demand. We want to process the jobs as quickly as possible, but each machine
incurs a cost based on how long it runs, so we try to optimize for both speed and expense.
The goal of this game is to process an imaginary queue of jobs as quickly and with as little
cost as possible.

## The Basics ##

We've set up an API that you can access to get all of the data you need for your game. It is
a turn-based game where each turn includes a batch of jobs that needs to be processed. For
each turn you will be given the batch of jobs, and then you will create or remove machines as necessary and assign
jobs to the machines for processing. Here are some basic ground rules:

1. There are two versions of the game, one with 500 turns and one with 50. Each turn contains between 1 and 40 jobs.

2. Each job requires a fixed amount of memory and a fixed number of turns to complete.

3. You can create machines whenever you want, and they are immediately available for jobs.

4. Each machine has 64GB of memory. If you assign greater than 64GB of jobs to a machine, the jobs will go on a queue for that machine and will be processed as memory is freed up in the order that they were assigned to the machine.

5. You can delete a machine whenever you want, but you will pay for it until all of its jobs, including the ones in its queue, have finished processing.

In general, a turn will look like this:

1. Pull the data for the turn, including its batch of jobs.

2. Create or remove machines as necessary to handle the new jobs.

3. Assign jobs to the machines for processing.

## Scoring ##

Each machine costs $1 per turn to operate. The goal is to process the jobs with as little delay as
possible while incurring the minimum possible cost. By querying the game object, you will get two
numbers that measure these values:

1. cost is the current total for the number of dollars spent.

2. delay_turns is the total number of turns between when jobs were given and when they started to execute.

The goal is to minimize these values. An approach that spins up a new machine for each job would have a delay_turns score of zero, but a very high cost. Alternatively, assigning all jobs to the same machine would give you a high value for both factors. The lowest possible value for delay_turns is zero, and we're not sure what the lowest possible cost is yet. We're less concerned with you getting perfect values for these things than with the organization of your code and your approach to the problem.

## API Endpoints ##

The game is operated by a RESTful API with the following endpoints:

1. Create a new game, which is the first thing you'll need to do in each run of your program.
This requires no parameters and returns some basic data about the game, including its id.
There are two games to play, the short one (50 turns) and the long one (500 turns). The short
one is the default, but we'll also test your code against the long one, so you may want to
try that out to make sure things scale before submitting.

    ```
    POST http://job-queue-dev.elasticbeanstalk.com/games

    Optional request body: { long: true }

    {
      "id":80, "cost":0, "current_turn":0, "completed":false,
      "created_at":"2015-04-02T12:46:24.024Z", "updated_at":"2015-04-02T12:46:24.024Z",
      "jobs_completed":0, "short":false, "delay_turns":0
    }
    ```

2. Get data about a game. This returns data in the same form as the create game call above.

    ```
    GET http://job-queue-dev.elasticbeanstalk.com/games/{game_id}
    ```

3. Advance to the next turn in the game. This will move you to the next turn, cycle out
jobs that have completed, and calculate the cost of the machines you have running. It returns
data about the jobs in the current turn as well as the state of the game.

    ```
    GET http://job-queue-dev.elasticbeanstalk.com/games/{game_id}/next_turn

    {
      "jobs":[
        {"id":32912,"turn":1,"turns_required":6,"memory_required":3}
      ],
      "status":"active", "machines_running":0, "jobs_running":0,
      "jobs_queued":0,"jobs_completed":0,"current_turn":1, "delay_turns":0
    }
    ```

4. Create a new machine.

    ```
    POST http://job-queue-dev.elasticbeanstalk.com/games/{game_id}/machines

    {
      "id":457,"game_id":80,"terminated":null
    }
    ```

5. Schedule a machine for termination.

    ```
    DELETE http://job-queue-dev.elasticbeanstalk.com/games/{game_id}/machines/{machine_id}

    {
      "id":457,
      "game_id":80,
      "terminated":true
    }
    ```

6. Assign jobs to a machine. This requires that you pass a job_ids parameter in the body that contains a JSON-encoded array of job ids to assign. It returns the number of jobs that were placed in the queue and added to the running list. The jobs will be executed strictly in the order that they are passed.

    ```
    POST http://job-queue-dev.elasticbeanstalk.com/games/{game_id}/machines/{machine_id}/job_assignments

    Request body: { job_ids: "[32912,32913]" }

    {
      "queued":0,
      "running":1
    }
    ```

## Reference Implementations ##

This project includes reference implementations written in Ruby and Javascript (with Node),
our two most-used languages at Custora. You can find them under the reference_implementations
folder. These implementations are given only for example purposes, and there
is no requirement that you start by using one, or even that your use one of these languages.
They are intentionally simple, but using them will give you a head start in terms of
connecting to the various API endpoints.

## Expectations ##

There is no need for you to work on this project until you get a perfect score. We're looking
for your code to be well organized and for you to have put some effort into finding a good
solution to the problem, but you shouldn't spend more than a few hours on this project.
You may implement it in any language you like. This is intended to be a fun opportunity for
you to showcase your skills rather than a contest to see who can get the lowest score.

## Submitting Your Project ##

When you've completed your project, zip up the code and a brief explanation of your solution
and email it to aubrey@custora.com. We will take a look at it within a couple of days and get back to you.

## Trouble? Problems? Questions? ##

If you run into problems along the way, feel free to email aubrey@custora.com, and we will
help you out.
