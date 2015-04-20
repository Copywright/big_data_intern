## The Basics ##

 It is a turn-based game where each turn includes a batch of jobs that needs to be processed. For
each turn you will be given the batch of jobs, and then you will create or remove machines as necessary and assign
jobs to the machines for processing. Here are some basic ground rules:

1. Each job requires a fixed amount of memory and a fixed number of turns to complete.

2. You can create machines whenever you want, and they are immediately available for jobs.

3. Each machine has 64GB of memory. If you assign greater than 64GB of jobs to a machine, the jobs will go on a queue for that machine and will be processed as memory is freed up in the order that they were assigned to the machine.


## Setup ##


1. First, let's bundle.

    ```
    bundle
    ```

2. Start the game.

    ```
    ruby big_data_intern.rb
    ```
