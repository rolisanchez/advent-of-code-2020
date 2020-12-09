import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

func isSum(target: Int, listNums: [Int]) -> Bool {
    for num in listNums {
        let num2 = target - num
        if listNums.contains(num2) {
            return true
        }
    }
    return false
}
do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n").map{ Int($0)! }

        let NUM_LINES = 25
        // let NUM_LINES = 5
        
        var index = NUM_LINES
        var startPreamble = 0
        var preamble: [Int] = Array(lines[startPreamble..<index])

        while index < lines.count {
            let target = lines[index]
            if !isSum(target: target, listNums: preamble) {
                break
            }
            index += 1
            startPreamble += 1
            preamble = Array(lines[startPreamble..<index])
        }
        print("Result: ", lines[index])
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}