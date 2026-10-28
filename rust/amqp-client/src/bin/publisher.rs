use rust_amqp_client_example::{connect, publish};

#[tokio::main]
async fn main() -> Result<(), amqp_client::Error> {
    let client = connect().await?;
    publish(&client, "hello", "Hello world!").await
}
