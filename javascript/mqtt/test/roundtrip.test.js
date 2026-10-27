import assert from "node:assert/strict"
import { execFile, spawn } from "node:child_process"
import { once } from "node:events"
import { createInterface } from "node:readline"
import { test } from "node:test"
import { promisify } from "node:util"

// Runs the worker and the publisher as a reader would
test("worker receives published message", { timeout: 10_000 }, async () => {
  const worker = spawn(process.execPath, ["worker.js"])
  try {
    const lines = createInterface({ input: worker.stdout })[Symbol.asyncIterator]()
    assert.match((await lines.next()).value, /Waiting for messages/)
    await promisify(execFile)(process.execPath, ["publisher.js"])
    assert.match((await lines.next()).value, /Received 'Hello world!'/)
  } finally {
    worker.kill()
    await once(worker, "exit")
  }
})
