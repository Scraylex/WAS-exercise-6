// lights controller agent

/* Initial beliefs */

// The agent has a belief about the location of the W3C Web of Thing (WoT) Thing Description (TD)
// that describes a Thing of type https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights (was:Lights)
td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", "https://raw.githubusercontent.com/Interactions-HSG/example-tds/was/tds/lights.ttl").

// The agent initially believes that the lights are "off"
lights("off").


/* Initial goals */ 

// The agent has the goal to start
!start.

/* 
 * Plan for reacting to the addition of the goal !start
 * Triggering event: addition of goal !start
 * Context: the agents believes that a WoT TD of a was:Lights is located at Url
 * Body: greets the user
*/
@start_plan
+!start : td("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#Lights", Url) <-
    makeArtifact("lights", "org.hyperagents.jacamo.artifacts.wot.ThingArtifact", [Url], ArtId);
    .print("Hello world").

@set_lights_state_plan
+!set_lights_state(State) : true <-
    invokeAction("https://was-course.interactions.ics.unisg.ch/wake-up-ontology#SetState",  ["https://www.w3.org/2019/wot/json-schema#StringSchema"], [State])[ArtId];
    .print("Set lights to state ", State);
    -+lights(State);
    .send(personal_assistant, tell, lights(State)).

@lights_on_plan
+!lights_on : true <-
    set_lights_state("on").

@lights_off_plan
+!lights_off : true <-
    set_lights_state("off").

@lights_plan
+lights(State) : true <-
    .print("The lights are ", State).

@manipulate_lights_pa_plan
+lights(State) : lights(State)[source(personal_assistant)] <-
    .print("Received from PA ", State);
    !set_lights_state(State);
    .send(personal_assistant, untell, wake_method("lights")).

@tell_wake_method_plan
+query_wake_method : lights("off") <-
    .print("telling PA: lights");
    .send(personal_assistant, tell, wake_method("lights")).


/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }