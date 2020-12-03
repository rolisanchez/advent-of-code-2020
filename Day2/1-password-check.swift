import Foundation

let filepath = "./input.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var validCounts = 0
        for line in lines {
            guard !line.isEmpty else { continue }

            let lineComponents = line.components(separatedBy: ":")
            let policyComponents = lineComponents[0].components(separatedBy: " ")
            let policyCountComponents = policyComponents[0].components(separatedBy: "-") // ex: 8-11
            let minCount = Int(policyCountComponents[0])!
            let maxCount = Int(policyCountComponents[1])!
            let policyLetter = policyComponents[1]
            let password = lineComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)

            
            let range = NSRange(location: 0, length: password.utf16.count)
            let regex = try! NSRegularExpression(pattern: "\(policyLetter){1,1}")

            let results = regex.matches(in: password, range: range)

            if results.count >= minCount && results.count <= maxCount {
                validCounts += 1
            }
        }

        print("Finished reading lines")
        print("validCounts: ", validCounts)
    }
    else {
        fatalError("Could not open file")
    }
}