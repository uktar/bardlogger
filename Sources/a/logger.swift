import Foundation

enum LogLevel: Int {
  case debug = 0
  case info = 1
  case warning = 2
  case error = 3

  var description: String {
    switch self {
    case .debug: return "Debug"
    case .info: return "Info"
    case .warning: return "Warning"
    case .error: return "Error"
    }
  }
}

class Logger {

  // MARK: - Properties

  private let dateFormatter = DateFormatter()
  private let fileManager = FileManager.default

  private var logPath: URL?

  // MARK: - Initializers

  init() {
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
  }

  // MARK: - Public Methods

  func log(message: String, level: LogLevel) {
    let log = "\(dateFormatter.string(from: Date())) - \(level.description) - \(message)\n"
    print(log)

    // Write the log to a file.
    if let logPath = logPath {
      do {
        let fileHandle = try FileHandle(forWritingTo: logPath)
        fileHandle.seekToEndOfFile()
        try fileHandle.write(log.data(using: .utf8)!)
      } catch {
        print(error)
      }
    } else {
      let logPath = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("logs.txt")
      self.logPath = logPath
      do {
        let fileHandle = try FileHandle(forWritingTo: logPath)
        fileHandle.seekToEndOfFile()
        try fileHandle.write(log.data(using: .utf8)!)
      } catch {
        print(error)
      }
    }
  }
}
