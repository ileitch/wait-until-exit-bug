import Foundation

func exec(
    _ cmd: String,
    _ args: [String],
    enableWorkaround: Bool = false
) throws -> (Int32, String, String) {
    let process = Process()
    process.launchPath = cmd
    process.arguments = args

    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()

    process.standardOutput = stdoutPipe
    process.standardError = stderrPipe

    process.launch()

    var standardOutput = ""
    var standardError = ""

    if let stdoutData = try stdoutPipe.fileHandleForReading.readToEnd() {
        guard let stdoutStr = String(data: stdoutData, encoding: .utf8)
        else { fatalError("Failed to decode stdout data") }
        standardOutput = stdoutStr
    }

    if let stderrData = try stderrPipe.fileHandleForReading.readToEnd() {
        guard let stderrStr = String(data: stderrData, encoding: .utf8)
        else { fatalError("Failed to decode stderr data") }
        standardError = stderrStr
    }

    if enableWorkaround {
        let semaphore = DispatchSemaphore(value: 0)
        process.terminationHandler = { _ in semaphore.signal() }
        semaphore.wait()
    } else {
        process.waitUntilExit()
    }

    return (process.terminationStatus, standardOutput, standardError)
}

print("Running /usr/bin/swift --version")
let (status, stdout, stderr) = try exec("/usr/bin/swift", ["--version"])
print("status: \(status)\nstdout: \(stdout)\nstderr: \(stderr)")
