<?php

namespace Example;

use PhpAmqpLib\Connection\AbstractConnection;
use PhpAmqpLib\Connection\AMQPConnectionConfig;
use PhpAmqpLib\Connection\AMQPConnectionFactory;

final class Amqp
{
    // Connects to CLOUDAMQP_URL, e.g. amqps://user:password@host/vhost
    public static function connect(): AbstractConnection
    {
        return AMQPConnectionFactory::create(self::config(getenv('CLOUDAMQP_URL') ?: 'amqp://guest:guest@localhost'));
    }

    // rawurldecode, not urldecode, so a literal "+" in a password is kept
    public static function config(string $amqpUrl): AMQPConnectionConfig
    {
        $url = parse_url($amqpUrl);
        $secure = $url['scheme'] === 'amqps';

        $config = new AMQPConnectionConfig();
        $config->setHost($url['host']);
        $config->setPort($url['port'] ?? ($secure ? 5671 : 5672));
        $config->setUser(rawurldecode($url['user'] ?? 'guest'));
        $config->setPassword(rawurldecode($url['pass'] ?? 'guest'));
        $config->setVhost(rawurldecode(ltrim($url['path'] ?? '', '/')) ?: '/');
        $config->setIsSecure($secure);

        return $config;
    }
}
