import Foundation
import MQTTNIO
import NIOCore
import NIOPosix

@main
struct Publisher {
    static func main() async throws {
        let env = ProcessInfo.processInfo.environment
        let port = Int(env["MQTT_PORT"] ?? "1883")!
        let client = MQTTClient(
            host: env["MQTT_HOST"] ?? "localhost",
            port: port,
            identifier: "publisher-\(UUID())",
            eventLoopGroupProvider: .shared(MultiThreadedEventLoopGroup.singleton),
            configuration: .init(userName: env["MQTT_USERNAME"] ?? "guest", password: env["MQTT_PASSWORD"] ?? "guest", useSSL: port == 8883)
        )
        try await client.connect()

        // QoS 1 returns once the broker has sent its PUBACK
        try await client.publish(to: "hello", payload: ByteBuffer(string: "Hello world!"), qos: .atLeastOnce)
        print(" [x] Sent 'Hello world!'")
        try await client.disconnect()
        try await client.shutdown()
    }
}
