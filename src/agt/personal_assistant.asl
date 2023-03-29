// personal assistant agent

/* Initial goals */ 

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
    !setupDweet;
    .wait(2000);
    publish("Hello world!").

@setup_dweet_artifact_plan
+!setupDweet : true <- 
    makeArtifact("dweet","room.DweetArtifact",[], DweetId);
    .print("Made artifact").

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }