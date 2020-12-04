import Foundation

// Use Hash Table Data Structure to find sum

let filepath = "./input.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var validPassports = 0
        var passportDict = [String:String]()

        for line in lines {
            if line.isEmpty { 
                // byr (Birth Year)
                // iyr (Issue Year)
                // eyr (Expiration Year)
                // hgt (Height)
                // hcl (Hair Color)
                // ecl (Eye Color)
                // pid (Passport ID)
                // cid (Country ID)

                // End of past passport info, verify all info
                if passportDict["byr"] == nil || passportDict["iyr"] == nil || passportDict["eyr"] == nil 
                || passportDict["hgt"] == nil || passportDict["hcl"] == nil || passportDict["ecl"] == nil 
                || passportDict["pid"] == nil {
                    // Invalid passport
                } else {
                    validPassports += 1
                }
                // Start a new passporr
                passportDict = [String:String]()
                
            } else {
                // Parse info in line
                let lineContents = line.components(separatedBy: " ")

                for content in lineContents {
                    let keyVal = content.components(separatedBy: ":")
                    passportDict[keyVal[0]] = keyVal[1]
                }
            }
            
        }

        print("validPassports: ", validPassports)

    }
}