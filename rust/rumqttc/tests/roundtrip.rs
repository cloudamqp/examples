use std::io::{BufRead, BufReader};
use std::process::{Command, Stdio};

// Runs the worker and the publisher as a reader would
#[test]
fn worker_receives_published_message() {
    let mut worker = Command::new(env!("CARGO_BIN_EXE_worker"))
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();
    let mut lines = BufReader::new(worker.stdout.take().unwrap()).lines();

    let waiting = lines.next().unwrap().unwrap();
    let published = Command::new(env!("CARGO_BIN_EXE_publisher"))
        .status()
        .unwrap();
    let received = lines.next().unwrap().unwrap();
    worker.kill().unwrap();
    worker.wait().unwrap();

    assert!(waiting.contains("Waiting for messages"), "{waiting}");
    assert!(published.success());
    assert!(
        received.contains("Received 'Hello world!'"),
        "{received}"
    );
}
