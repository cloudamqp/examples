import { AMQPSession } from "@cloudamqp/amqp-client"

// The session reconnects automatically and recovers consumers
export function connect(): Promise<AMQPSession> {
  return AMQPSession.connect(process.env.BROKER_URL || "amqp://guest:guest@localhost")
}
