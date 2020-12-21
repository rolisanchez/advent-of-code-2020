import Foundation

// let filepath = "./input.txt"
let filepath = "./input2.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let groups = contents.components(separatedBy: "\n\n")

        // Runs in small sets, such as the test input
        // runSmallRuleset(groups: groups)
        runBigRuleset(groups: groups)
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func runSmallRuleset(groups: [String]) {
    let rules = groups[0].components(separatedBy: "\n")
    let messages = groups[1].components(separatedBy: "\n")

    let rulesDict = parseRulesLines(rules: rules)
    
    let ruleZero = rulesDict[0]!.replacingOccurrences(of: " ", with: "")
    print("zero: ", ruleZero)
    let regex = try! NSRegularExpression(pattern: "^\(ruleZero)$")
    
    var matchCount = 0
    for message in messages {
        let range = NSRange(location: 0, length: message.utf16.count)

        if regex.firstMatch(in: message, options: [], range: range) != nil {
            matchCount += 1
        }
    }
    
    print("Result: ", matchCount)
}
func parseRulesLines(rules: [String]) -> [Int:String]{
    var rulesDict = [Int:String]()

    for rule in rules {
        let ruleComps = rule.components(separatedBy: ": ")
        let ruleId = Int(ruleComps[0])!
        let ruleValues = "("+ruleComps[1].replacingOccurrences(of: "\"", with: "")+")"
        rulesDict[ruleId] = ruleValues
    }
    print(rulesDict.count)
    var shouldContinue = true
    var it = 0
    while shouldContinue {
        shouldContinue = false
        var ruleZero = rulesDict[0]!
        let nums = ruleZero.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap{Int($0)}.sorted(by: >)
        
        print("Count: ", nums.count)
        if nums.count > 0 {
            shouldContinue = true
        }
        for num in nums {
            if rulesDict[num] == nil {
                print("ERROR: ", num)
                print("ERROR: ", nums)
                print("ERROR: ", ruleZero)
            }

            ruleZero = ruleZero.replacingOccurrences(of: "\(num)", with: "("+rulesDict[num]!+")")
        }
        rulesDict[0] = ruleZero

        print("Still processing... \(it)")
        it += 1
    }
    

    
    return rulesDict
}

struct Rule {
    let condition1: [Int]?
    let condition2: [Int]?
    
    let char: Character?
}

func runBigRuleset(groups: [String]) {
    let rulesArr = groups[0].components(separatedBy: "\n")
    let messages = groups[1].components(separatedBy: "\n")

    let rules = rulesArr.map { line -> (Int, Rule) in
        let parts = line.components(separatedBy: ": ")
        let ruleNumber = Int(parts[0])!
        let rule = parts[1]
        var char: Character? = nil
        var condition1: [Int]? = nil
        var condition2: [Int]? = nil
        if rule.contains("\"") {
            char = rule[rule.index(rule.startIndex, offsetBy: 1)]
        } else if rule.contains("|") {
            let rulePair = rule.components(separatedBy: " | ")
            let t = rulePair[0].components(separatedBy: " ")
            condition1 = t.map { Int($0)! }
            condition2 = rulePair[1].components(separatedBy: " ").map { Int($0)! }
        } else {
            condition1 = rule.components(separatedBy: " ").map { Int($0)! }
        }
        return (ruleNumber, Rule(condition1: condition1, condition2: condition2, char: char))
    }

    let rulesDict = Dictionary(uniqueKeysWithValues: rules)

    let expressions = messages.map { message in
        ruleMatches([message], ruleNumber: 0, rulesDict: rulesDict)
    }
    print(expressions.filter { $0?.contains("") == true })
    print(expressions.filter { $0?.contains("") == true }.count)
}

func ruleMatches(_ exs: [String], ruleNumber: Int, rulesDict: [Int: Rule]) -> [String]? {
    let rule = rulesDict[ruleNumber]
    if let char = rule?.char {
        return exs.compactMap { ex in
                if ex.first == char {
                    return String(ex[ex.index(ex.startIndex, offsetBy: 1)..<ex.endIndex])
            } else {
                return nil
            }
        }
    }
    var condition1Matches = [String]()
    if let condition1 = rule?.condition1 {
        for ex in exs {
            if ex != "" {
                var leftovers: [String]? = [ex]
                for ruleNumber in condition1 {
                    if let leftoversNN = leftovers {
                        leftovers = ruleMatches(leftoversNN, ruleNumber: ruleNumber, rulesDict: rulesDict)
                    }
                }
                
                if let leftoversNN = leftovers {
                    condition1Matches.append(contentsOf: leftoversNN)
                }
            }
        }
    }
    var condition2Matches = [String]()
    if let condition2 = rule?.condition2 {
        for ex in exs {
            if ex != "" {
                var leftovers: [String]? = [ex]
                for ruleNumber in condition2 {
                    if let leftoversNN = leftovers {
                        leftovers = ruleMatches(leftoversNN, ruleNumber: ruleNumber, rulesDict: rulesDict)
                    }
                }
                
                if let leftoversNN = leftovers {
                    condition2Matches.append(contentsOf: leftoversNN)
                }
            }
        }
    }
    return condition1Matches + condition2Matches
}