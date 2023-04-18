// personal assistant agent

wake_up :- upcoming(Event) & owner_state(State) & Event == "now" & State == "asleep".
all_good :- upcoming(Event) & owner_state(State) & Event == "now" & State == "awake".

best_wake_method(State, Pos) :- wake_method(State) & wake_with(State, Pos) & current_option(Value) & Pos == Value.

/* Initial goals */
current_option(0).
wake_with("lights", 1).
wake_with("blinds", 0).

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
    .wait(2000);
    !wakeOwner;

    //!setupDweet;
    //publish("Hello world!");
    
    !start.

@wake_owner_plan
+!wakeOwner : wake_up <-
    .print("Waking owner");
    .broadcast(tell, query_wake_method);
    !handle_waking.

@wake_with_lights_plan
+!handle_waking : best_wake_method("lights", 1) <-
    .send(tell, lights_controller, lights("on"));
    -current_option(1);
    .print("Sent lights on").

@wake_with_blinds_plan
+!handle_waking : best_wake_method("blinds", 0) <-
    .send(tell, blinds_controller, blinds("raised"));
    -+current_option(1);
    .print("Sent blinds raised").

-!handle_waking : true <-
    .print("No waking plan available").

@owner_awake_plan
+!wakeOwner : all_good <-
    .print("Have fun at the event").


@setup_dweet_artifact_plan
+!setupDweet : true <- 
    makeArtifact("dweet","room.DweetArtifact",[], DweetId);
    .print("Made artifact").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }