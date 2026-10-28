use std::env;

use rumqttc::{Client, Event, MqttOptions, Packet, QoS, Transport};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let host = env::var("MQTT_HOST").unwrap_or("localhost".into());
    let port = env::var("MQTT_PORT").unwrap_or("1883".into()).parse()?;
    let mut options = MqttOptions::new(format!("worker-{}", std::process::id()), host, port);
    options.set_credentials(
        env::var("MQTT_USERNAME").unwrap_or("guest".into()),
        env::var("MQTT_PASSWORD").unwrap_or("guest".into()),
    );
    if port == 8883 {
        options.set_transport(Transport::tls_with_default_config());
    }
    let (client, mut connection) = Client::new(options, 10);

    client.subscribe("hello", QoS::AtLeastOnce)?;
    // rumqttc acks each QoS 1 message as it arrives
    for event in connection.iter() {
        match event? {
            Event::Incoming(Packet::SubAck(_)) => {
                println!(" [*] Waiting for messages. To exit press CTRL+C")
            }
            Event::Incoming(Packet::Publish(message)) => {
                println!(
                    " [x] Received '{}'",
                    String::from_utf8_lossy(&message.payload)
                )
            }
            _ => {}
        }
    }
    Ok(())
}
