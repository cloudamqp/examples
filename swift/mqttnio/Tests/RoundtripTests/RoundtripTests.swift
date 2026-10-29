import Foundation
import Testing

// Runs the worker and the publisher as a reader would. SwiftPM builds them
// next to the test binary
@Test func workerReceivesPublishedMessage() throws {
    let products = Bundle.main.executableURL!.deletingLastPathComponent()
    let output = Pipe()
    let worker = Process()
    worker.executableURL = products.appendingPathComponent("worker")
    worker.standardOutput = output
    try worker.run()
    defer { worker.terminate() }

    #expect(readLine(output.fileHandleForReading)?.contains("Waiting for messages") == true)
    let publisher = try Process.run(products.appendingPathComponent("publisher"), arguments: [])
    publisher.waitUntilExit()
    #expect(publisher.terminationStatus == 0)
    #expect(readLine(output.fileHandleForReading)?.contains("Received 'Hello world!'") == true)
}

func readLine(_ handle: FileHandle) -> String? {
    var line = Data()
    while let byte = try? handle.read(upToCount: 1), !byte.isEmpty, byte != Data("\n".utf8) {
        line.append(byte)
    }
    return line.isEmpty ? nil : String(decoding: line, as: UTF8.self)
}
