
import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let groups = contents.components(separatedBy: "\n\n")
        let rulesInfo = groups[0].components(separatedBy: "\n")
        var myTicketInfo = groups[1].components(separatedBy: "\n")
        myTicketInfo = Array(myTicketInfo[1..<myTicketInfo.count])
        var nearbyTickersInfo = groups[2].components(separatedBy: "\n")
        nearbyTickersInfo = Array(nearbyTickersInfo[1..<nearbyTickersInfo.count])
        // print(rulesInfo)
        // print(myTicketInfo)
        // print(nearbyTickersInfo)
        var ruleRangesArr = [ClosedRange<Int>]()
        // Process Rules
        for rule in rulesInfo {
            let ruleComps = rule.components(separatedBy: ":")
            // let ruleName = ruleComps[0]
            let ruleRanges = ruleComps[1].components(separatedBy: "or").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            for ruleRangeUntrimmed in ruleRanges {
                // let trimmedComps = ruleRangeUntrimmed.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "-").map{ Int($0)! }
                let trimmedComps = ruleRangeUntrimmed.components(separatedBy: "-").map{ Int($0)! }
                let range = trimmedComps[0]...trimmedComps[1]
                ruleRangesArr.append(range)
            }
            
        }

        var invalidVals = [Int]()
        for nearbyTicket in nearbyTickersInfo {
            let ticketVals = nearbyTicket.components(separatedBy: ",").map{ Int($0)! }

            for ticketVal in ticketVals {
                var validTicket = false
                for closedRange in ruleRangesArr {
                    if closedRange.contains(ticketVal) {
                        validTicket = true
                        break
                    }
                }
                if !validTicket {
                    invalidVals.append(ticketVal)
                }
            }
        }
        
        print("Result: ", invalidVals.reduce(0){ $0 + $1 })
        // Process nearby tickets
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}