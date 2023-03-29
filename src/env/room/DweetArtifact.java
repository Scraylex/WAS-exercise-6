package room;

import cartago.Artifact;
import cartago.OPERATION;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

/**
 * A CArtAgO artifact that provides an operation for sending messages to agents 
 * with KQML performatives using the dweet.io API
 */
public class DweetArtifact extends Artifact {

    private static final String DWEET_URI = "https://dweet.io/dweet/for/lukas-was";

    void init() {

    }

    @OPERATION
    void publish(String message) {

        final var dweet = """
                {"message": "%s"}
                """.formatted(message);

        System.out.println(dweet);
        final var client = HttpClient.newHttpClient();
        final var request = HttpRequest.newBuilder(URI.create(DWEET_URI))
                .POST(HttpRequest.BodyPublishers.ofString(dweet))
                .header("Content-Type", "application/json")
                .build();
        try {
            final var send = client.send(request, HttpResponse.BodyHandlers.discarding());
            if(send.statusCode() > 200) {
                System.out.println(send.statusCode());
                System.out.println("Something went wrong");
            }
        } catch (IOException | InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
