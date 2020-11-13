
import Foundation
import SwiftCLI

class DiffCommand: Command {
    var name = "diff"
    var shortDescription: String = "Runs a comparison between 2 JSON API logs and prints detected breaking changes."
    
    @Param var oldProjectPath: String
    @Param var newProjectPath: String
    
    func execute() throws {
        guard try runApiDiff(oldApiPath: absURL(oldProjectPath),
                             newApiPath: absURL(newProjectPath)) else {
            exit(1)
        }
    }
    
    private func runApiDiff(oldApiPath: URL, newApiPath: URL) throws -> Bool {
        let oldApi = try readJson(at: oldApiPath)
        let newApi = try readJson(at: newApiPath)
        let report = try diffreport(oldApi: oldApi, newApi: newApi)
        
        if report.isEmpty {
            print("No breaking changes detected!")
            return true
        } else {
            print("\n**** BREAKING CHANGES DETECTED ****")
            for (symbol, change) in report {
                print("\nBreaking changes in '\(symbol)'")
                print(change.map({ $0.toMarkdown() }).joined(separator: "\n\n"))
            }
            return false
        }
    }
    
    private func readJson(at path: URL) throws -> Any {
        let data = try Data(contentsOf: path)
        
        if !data.isEmpty {
            return try JSONSerialization.jsonObject(with: data)
        } else {
            return []
        }
    }
}
