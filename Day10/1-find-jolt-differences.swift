import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"


do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n").map{ Int($0)! }
        let maxJolts = lines.max()!
        
        // print("adapterJolts: ", adapterJolts)

        // Start with outlet jolts
        var currentJolts = 0
        
        var oneJoltsDiffs = 0
        var twoJoltsDiffs = 0
        var threeJoltsDiffs = 0

        while currentJolts < maxJolts {
            if lines.contains(currentJolts+1) {
                currentJolts += 1
                oneJoltsDiffs += 1
            } else if lines.contains(currentJolts+2) {
                currentJolts += 2
                twoJoltsDiffs += 1
            } else if lines.contains(currentJolts+3) {
                currentJolts += 3
                threeJoltsDiffs += 1
            }
        }

        threeJoltsDiffs += 1

        print("oneJoltsDiffs: ", oneJoltsDiffs)
        print("twoJoltsDiffs: ", twoJoltsDiffs)
        print("threeJoltsDiffs: ", threeJoltsDiffs)

        print("Mult: ", oneJoltsDiffs*threeJoltsDiffs)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}