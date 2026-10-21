<?php

use Example\Amqp;
use PHPUnit\Framework\TestCase;

final class AmqpTest extends TestCase
{
    public function testUrlEncodedPartsAreDecoded(): void
    {
        $config = Amqp::config('amqp://us%40er:p%2Fss@localhost/my%2Fvhost');

        $this->assertSame('us@er', $config->getUser());
        $this->assertSame('p/ss', $config->getPassword());
        $this->assertSame('my/vhost', $config->getVhost());
    }

    public function testPlusInCredentialsIsKept(): void
    {
        $config = Amqp::config('amqp://us+er:p+ss@localhost');

        $this->assertSame('us+er', $config->getUser());
        $this->assertSame('p+ss', $config->getPassword());
    }
}
