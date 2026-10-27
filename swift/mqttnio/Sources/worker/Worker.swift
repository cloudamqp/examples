import Foundation
import MQTTNIO
import NIOCore
import NIOPosix

@main
struct Worker {
    static func main() async throws {
        let env = ProcessInfo.processInfo.environment
        let port = Int(env["MQTT_PORT"] ?? "1883")!
        let client = MQTTClient(
            host: env["MQTT_HOST"] ?? "localhost",
            port: port,
            identifier: "worker-\(UUID())",
            eventLoopGroupProvider: .shared(MultiThreadedEventLoopGroup.singleton),
            configuration: .init(userName: env["MQTT_USERNAME"] ?? "guest", password: env["MQTT_PASSWORD"] ?? "guest", useSSL: port == 8883)
        )
        try await client.connect()

        // Listen before subscribing, so no message is missed
        let listener = client.createPublishListener()
        _ = try await client.subscribe(to: [MQTTSubscribeInfo(topicFilter: "hello", qos: .atLeastOnce)])
        print(" [*] Waiting for messages. To exit press CTRL+C")
        // Flush, so the output shows straight away also when it's piped
        fflush(nil)
        // MQTT NIO acks each QoS 1 message before it is passed on
        for await result in listener {
            print(" [x] Received '\(String(buffer: try result.get().payload))'")
            fflush(nil)
        }
    }
}
