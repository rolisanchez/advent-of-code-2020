
import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"
// let filepath = "./testinput2.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let groups = contents.components(separatedBy: "\n\n")
        let rulesInfo = groups[0].components(separatedBy: "\n")
        let myTicketInfo = groups[1].components(separatedBy: "\n")[1].components(separatedBy: ",").map { Int($0)! }

        let nearbyTickersInfoStr = groups[2].components(separatedBy: "\n")
        let nearbyTickersInfo = Array(nearbyTickersInfoStr[1..<nearbyTickersInfoStr.count]).map { $0.components(separatedBy: ",").map{ Int($0)! }}

        var ruleRangesArr = [ClosedRange<Int>]()
        var rulesWithNames = [String:[ClosedRange<Int>]]()
        var validIndexesForField = [String:[Int]]()
        // Process Rules
        for rule in rulesInfo {
            let ruleComps = rule.components(separatedBy: ":")
            let ruleName = ruleComps[0]
            let ruleRanges = ruleComps[1].components(separatedBy: "or").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            var thisRules = [ClosedRange<Int>]()
            for ruleRangeUntrimmed in ruleRanges {
                // let trimmedComps = ruleRangeUntrimmed.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "-").map{ Int($0)! }
                let trimmedComps = ruleRangeUntrimmed.components(separatedBy: "-").map{ Int($0)! }
                let range = trimmedComps[0]...trimmedComps[1]
                ruleRangesArr.append(range)
                thisRules.append(range)
            }
            rulesWithNames[ruleName] = thisRules
            validIndexesForField[ruleName] = [Int]()
        }
        
        var validTickets = [[Int]]()

        for ticketVals in nearbyTickersInfo {

            var validTicket = true

            for ticketVal in ticketVals {
                var validVal = false
                for closedRange in ruleRangesArr {
                    if closedRange.contains(ticketVal) {
                        validVal = true
                        break
                    }
                }
                if !validVal {
                    validTicket = false
                }
            }

            if validTicket {
                validTickets.append(ticketVals)
            }
        }

        // Need to check

        //          Field 1 , Field 2, Field 3 Ok?
        // Ticket1     X                  X
        // Ticket2     X        X         X
        // Ticket3              X         X

        // Only Field 3 is true for all tickets
        // If any ticket is false for a field, skip and go to next field
        
        // 
        let fieldsCount = validTickets[0].count

        for (ruleName, ruleRanges) in rulesWithNames {
            for i in 0..<fieldsCount {
                var validFieldForTicket = true
                for validTicket in validTickets {
                    let fieldValue = validTicket[i]
                    var validFieldValue = false 
                    for rule in ruleRanges {
                        if rule.contains(fieldValue) {
                            validFieldValue = true
                            break
                        }
                    }
                    if !validFieldValue {
                        validFieldForTicket = false
                        break
                    }
                }
                if validFieldForTicket == true {
                    validIndexesForField[ruleName]!.append(i)
                }
            }
        }
        
        print("Valid tickets count: ", validTickets.count)

        var sortedFieldsValues = validIndexesForField.sorted { $0.1.count < $1.1.count }
        var finalValidIndexForField = [String:Int]()
        
        while finalValidIndexForField.count < validIndexesForField.count {
            for (key, value) in sortedFieldsValues {
                if value.count == 1 {
                    finalValidIndexForField[key] = value[0]

                    for (key2, values) in validIndexesForField {
                        if let index = values.firstIndex(of:value[0]) {
                            validIndexesForField[key2]!.remove(at: index)
                        }
                    }
                    
                    sortedFieldsValues = validIndexesForField.sorted { $0.1.count < $1.1.count }
                }
            }
        }

        var multDepartures = 1
        multDepartures *= myTicketInfo[finalValidIndexForField["departure location"]!]
        multDepartures *= myTicketInfo[finalValidIndexForField["departure station"]!]
        multDepartures *= myTicketInfo[finalValidIndexForField["departure platform"]!]
        multDepartures *= myTicketInfo[finalValidIndexForField["departure track"]!]
        multDepartures *= myTicketInfo[finalValidIndexForField["departure date"]!]
        multDepartures *= myTicketInfo[finalValidIndexForField["departure time"]!]

        print("Result: ", multDepartures)
        // Process nearby tickets
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}