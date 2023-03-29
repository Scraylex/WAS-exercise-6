// personal assistant agent

wake_up :- upcoming(Event) & owner_state(State) & Event == "now" & State == "asleep".
all_good :- upcoming(Event) & owner_state(State) & Event == "now" & State == "awake".

best_wake_method("lights") :- wake_method("lights") & wake_with_artificial_light(X) & wake_with_natural_light(Y) & X < Y.
best_wake_method("blinds") :- wake_method("blinds") & wake_with_artificial_light(X) & wake_with_natural_light(Y) & X > Y.

/* Initial goals */

wake_with_natural_light(0).
wake_with_artificial_light(1).

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: true (the plan is always applicable)
 * Body: greets the user
*/
@start_plan
+!start : true <-
    .print("Hello world");
    //!setupDweet;
    .wait(2000);
    //publish("Hello world!");
    !start.

@wake_owner_plan
+!wakeOwner : wake_up <-
    .broadcast(askAll, wake_method, Answers);
    !use_answer(Answers)
    .print("lol, ", Answers).

@select_wake_method_plan
+!use_answer(Answers) : true <-
    .print("Think about this").

@owner_awake_plan
+!ownerAwake : all_good <-
    .print("Have fun at the event").


@setup_dweet_artifact_plan
+!setupDweet : true <- 
    makeArtifact("dweet","room.DweetArtifact",[], DweetId);
    .print("Made artifact").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }