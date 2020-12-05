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
            let policyPositionComponents = policyComponents[0].components(separatedBy: "-") // ex: 8-11
            let pos1 = Int(policyPositionComponents[0])!
            let pos2 = Int(policyPositionComponents[1])!
            let policyLetter = Character(policyComponents[1])
            let password = lineComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)

            let letter1 = password[password.index(password.startIndex, offsetBy: (pos1-1))]
            let letter2 = password[password.index(password.startIndex, offsetBy: (pos2-1))]
            
            if letter1 != letter2 && (letter1 == policyLetter || letter2 == policyLetter) {
                validCounts += 1
            }

        }

        print("Finished reading lines")
        print("validCounts: ", validCounts)
    } else {
        fatalError("Could not open file")
    }
}