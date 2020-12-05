import Foundation

// Use Hash Table Data Structure to find sum

func arePassportKeysValid(_ passportDict: [String:String]) -> Bool {
    // byr (Birth Year)
    // iyr (Issue Year)
    // eyr (Expiration Year)
    // hgt (Height)
    // hcl (Hair Color)
    // ecl (Eye Color)
    // pid (Passport ID)
    // cid (Country ID)
    if passportDict["byr"] == nil || passportDict["iyr"] == nil || passportDict["eyr"] == nil 
        || passportDict["hgt"] == nil || passportDict["hcl"] == nil || passportDict["ecl"] == nil 
        || passportDict["pid"] == nil {
        return false
    }
    return true
}

func arePassportFieldsValid(_ passportDict: [String:String]) -> Bool {
    // byr (Birth Year) - four digits; at least 1920 and at most 2002.
    guard let byrStr = passportDict["byr"], byrStr.count == 4, let byr = Int(byrStr), byr >= 1920, byr <= 2002 else {
        return false
    }
    // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
     guard let iyrStr = passportDict["iyr"], iyrStr.count == 4, let iyr = Int(iyrStr), iyr >= 2010, iyr <= 2020 else {
        return false
    }
    // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
    guard let eyrStr = passportDict["eyr"], eyrStr.count == 4, let eyr = Int(eyrStr), eyr >= 2020, eyr <= 2030 else {
        return false
    }
    // hgt (Height) - a number followed by either cm or in:
    // If cm, the number must be at least 150 and at most 193.
    // If in, the number must be at least 59 and at most 76.
    let hgt = passportDict["hgt"]!
    let rangeHgt = NSRange(location: 0, length: hgt.utf16.count)
    
    let regexHgt = try! NSRegularExpression(pattern: "\\d{2,3}(cm|in)")

    if regexHgt.firstMatch(in: hgt, options: [], range: rangeHgt) == nil {
        return false
    } else {
        let unitIndex = hgt.index(hgt.endIndex, offsetBy: -2)
        let heightNum = hgt[hgt.startIndex..<unitIndex]
        let unit = hgt[unitIndex..<hgt.endIndex]
        if (unit == "cm") && (Int(heightNum)! < 150 || Int(heightNum)! > 193) {
            // print("heightNum: ", heightNum)
            // print("unit: ", unit)
            return false
        } else if (unit == "in") && (Int(heightNum)! < 59 || Int(heightNum)! > 76) {
            // print("heightNum: ", heightNum)
            // print("unit: ", unit)
            return false
        }
    }

    // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
    
    let hcl = passportDict["hcl"]!
    let rangeHcl = NSRange(location: 0, length: hcl.utf16.count)
    
    let regexHcl = try! NSRegularExpression(pattern: "^#[0-9a-fA-F]{6}$")

    if regexHcl.firstMatch(in: hcl, options: [], range: rangeHcl) == nil {
        return false
    }
    // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
    let ecl = passportDict["ecl"]!
    let rangeEcl = NSRange(location: 0, length: ecl.utf16.count)
    
    let regexEcl = try! NSRegularExpression(pattern: "^(amb|blu|brn|gry|grn|hzl|oth)$")

    if regexEcl.firstMatch(in: ecl, options: [], range: rangeEcl) == nil {
        return false
    }
    // pid (Passport ID) - a nine-digit number, including leading zeroes.
    guard let pidStr = passportDict["pid"], pidStr.count == 9, let _ = Int(pidStr) else {
        return false
    }
    // cid (Country ID) - ignored, missing or not.

    return true
}

let filepath = "./input.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var validPassports = 0
        var passportDict = [String:String]()

        for line in lines {
            if line.isEmpty { 
                if arePassportKeysValid(passportDict) && arePassportFieldsValid(passportDict){ 
                    validPassports += 1 
                }
                // Start a new passport
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

    } else {
        fatalError("Could not open file")
    }
}