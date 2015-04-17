var request = require('request');

var host = 'http://job-queue-dev.elasticbeanstalk.com';

var totalJobsFound = 0;

var assignJobsWithNewMachine = function(game, machine, turn) {
  request.del(
    host + '/games/' + game.id + '/machines/' + machine.id,
    function (error, response, body) {
      request.post(
        host + '/games/' + game.id + '/machines',
        { form: {} },
        function (error, response, body) {
          assignJobs(game, JSON.parse(body), turn, true);
        }
      );
    }
  );
};

//
// Assign all of the given jobs to the machine
//
var assignJobs = function(game, machine, turn, skipNewMachine) {
  //
  // Just to show how machine deletion works, I'm deleting the current
  // machine every 25 turns and replacing it with a new one.
  //
  if (!skipNewMachine && (turn.current_turn % 25) == 0) {
    assignJobsWithNewMachine(game, machine, turn);
  } else {
    status = turn.status;
    totalJobsFound += turn.jobs.length;

    console.log("On turn " +
      turn.current_turn +
      " got " + turn.jobs.length + " jobs, having completed " +
      turn.jobs_completed +
      " of " +
      totalJobsFound +
      " with " + turn.jobs_running + " jobs running, and " +
      turn.jobs_queued + " jobs queued, and " +
      turn.machines_running + " machines running."
    );

    //
    // When the status is completed, the game is over.
    //
    if (status != 'completed') {
      //
      // Get the ids for each job
      //
      jobIds = [];
      turn.jobs.forEach(function(job) {
        jobIds.push(job.id);
      });

      //
      // If there are any jobs, assign them all to the current machine and then
      // move on to the next turn. If there are no jobs, go straight to the next turn.
      // 
      if (jobIds.length > 0) {
        request.post(
          host + '/games/' + game.id + '/machines/' + machine.id + '/job_assignments',
          { form: { job_ids: JSON.stringify(jobIds) } },
          function (error, response, body) {
            nextTurn(game, machine);
          }
        );
      } else {
        nextTurn(game, machine);
      }
    } else {
      request.get(
        host + '/games/' + game.id,
        function (error, response, body) {
          console.log(body);
          console.log("\n\n");
          var completedGame = JSON.parse(body);
          console.log("COMPLETED GAME WITH:");
          console.log("Total delay: " + completedGame.delay_turns + " turns"); 
          console.log("Total cost:  $" + completedGame.cost); 
        }
      );
    }
  }
};

//
// Pull the data for the next turn
//
var nextTurn = function(game, machine) {
  request.get(
    host + '/games/' + game.id + '/next_turn',
    function (error, response, body) {
      assignJobs(game, machine, JSON.parse(body));
    }
  );
};

//
// Create a machine to play the game with and then start processing turns
//
var playGameWithMachine = function(game) {
  request.post(
    host + '/games/' + game.id + '/machines',
    { form: {} },
    function (error, response, body) {
      nextTurn(game, JSON.parse(body));
    }
  );
};

//
// Kick off the game by posting to the new game endpoint
//
var playGame = function() {
  request.post(
    host + '/games',
    { form: {} },
    // { form: { long: true } },
    function (error, response, body) {
      playGameWithMachine(JSON.parse(body));
    }
  );
};

playGame();
