# Big Data Intern #

Big Data Intern is the result of boredom and inactivity at the time of receiving a cool code challenge.

## The Basics ##

 It is a turn-based game where each turn includes a batch of jobs that needs to be processed. For
each turn you will be given the batch of jobs, and then you will create or remove machines as necessary and assign
jobs to the machines for processing. Here are some basic ground rules:

1. There are two versions of the game, one with 500 turns and one with 50. Each turn contains between 1 and 40 jobs.

2. Each job requires a fixed amount of memory and a fixed number of turns to complete.

3. You can create machines whenever you want, and they are immediately available for jobs.

4. Each machine has 64GB of memory. If you assign greater than 64GB of jobs to a machine, the jobs will go on a queue for that machine and will be processed as memory is freed up in the order that they were assigned to the machine.

5. You can delete a machine whenever you want, but you will pay for it until all of its jobs, including the ones in its queue, have finished processing.


## Setup ##


1. First, let's bundle.

    ```
    bundle
    ```

2. Start the game.

    ```
    ruby big_data_intern.rb
    ```
