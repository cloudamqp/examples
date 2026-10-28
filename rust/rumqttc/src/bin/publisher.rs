use std::env;

use rumqttc::{Client, Event, MqttOptions, Packet, QoS, Transport};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let host = env::var("MQTT_HOST").unwrap_or("localhost".into());
    let port = env::var("MQTT_PORT").unwrap_or("1883".into()).parse()?;
    let mut options = MqttOptions::new(format!("publisher-{}", std::process::id()), host, port);
    options.set_credentials(
        env::var("MQTT_USERNAME").unwrap_or("guest".into()),
        env::var("MQTT_PASSWORD").unwrap_or("guest".into()),
    );
    if port == 8883 {
        options.set_transport(Transport::tls_with_default_config());
    }
    let (client, mut connection) = Client::new(options, 10);

    client.publish("hello", QoS::AtLeastOnce, false, "Hello world!")?;
    // The connection sends the message; QoS 1 waits for the broker's PUBACK
    for event in connection.iter() {
        if let Event::Incoming(Packet::PubAck(_)) = event? {
            println!(" [x] Sent 'Hello world!'");
            break;
        }
    }
    client.disconnect()?;
    Ok(())
}
