<?php

require __DIR__ . '/vendor/autoload.php';

use Example\Amqp;
use Example\Publisher;

$connection = Amqp::connect();
Publisher::publish($connection->channel(), 'hello', 'Hello world!');
$connection->close();
