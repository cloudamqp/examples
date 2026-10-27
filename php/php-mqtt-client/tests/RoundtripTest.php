<?php

use PHPUnit\Framework\TestCase;

final class RoundtripTest extends TestCase
{
    // Runs the worker and the publisher as a reader would
    public function testWorkerReceivesPublishedMessage(): void
    {
        $root = dirname(__DIR__);
        $worker = proc_open([PHP_BINARY, 'worker.php'], [1 => ['pipe', 'w']], $pipes, $root);
        try {
            $this->assertStringContainsString('Waiting for messages', fgets($pipes[1]));
            exec(PHP_BINARY . ' ' . escapeshellarg("$root/publisher.php"), $output, $status);
            $this->assertSame(0, $status);
            $this->assertStringContainsString("Received 'Hello world!'", fgets($pipes[1]));
        } finally {
            proc_terminate($worker);
        }
    }
}
