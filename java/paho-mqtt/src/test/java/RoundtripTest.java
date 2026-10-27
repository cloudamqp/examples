import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Timeout;

class RoundtripTest {
  // Runs the worker and the publisher as a reader would
  @Test
  @Timeout(30)
  void workerReceivesPublishedMessage() throws Exception {
    Process worker = java("Worker").start();
    try (BufferedReader output = new BufferedReader(new InputStreamReader(worker.getInputStream()))) {
      assertTrue(output.readLine().contains("Waiting for messages"));
      assertTrue(java("Publisher").inheritIO().start().waitFor() == 0);
      assertTrue(output.readLine().contains("Received 'Hello world!'"));
    } finally {
      worker.destroy();
    }
  }

  private static ProcessBuilder java(String mainClass) {
    String java = Path.of(System.getProperty("java.home"), "bin", "java").toString();
    return new ProcessBuilder(java, "-cp", System.getProperty("java.class.path"), mainClass);
  }
}
