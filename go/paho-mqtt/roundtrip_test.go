package roundtrip

import (
	"bufio"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

// Builds and runs the worker and the publisher as a reader would
func TestWorkerReceivesPublishedMessage(t *testing.T) {
	bin := t.TempDir()
	if out, err := exec.Command("go", "build", "-o", bin, "./publisher", "./worker").CombinedOutput(); err != nil {
		t.Fatalf("%v: %s", err, out)
	}

	worker := exec.Command(filepath.Join(bin, "worker"))
	stdout, err := worker.StdoutPipe()
	if err != nil {
		t.Fatal(err)
	}
	if err := worker.Start(); err != nil {
		t.Fatal(err)
	}
	defer worker.Process.Kill()
	lines := bufio.NewScanner(stdout)

	if !lines.Scan() || !strings.Contains(lines.Text(), "Waiting for messages") {
		t.Fatalf("worker didn't subscribe: %q", lines.Text())
	}
	if out, err := exec.Command(filepath.Join(bin, "publisher")).CombinedOutput(); err != nil {
		t.Fatalf("%v: %s", err, out)
	}
	if !lines.Scan() || !strings.Contains(lines.Text(), "Received 'Hello world!'") {
		t.Fatalf("worker didn't receive the message: %q", lines.Text())
	}
}
