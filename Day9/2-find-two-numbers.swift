import Foundation

let filepath = "./input.txt"
let NUM_LINES = 25
let target = 22406676
// let filepath = "./testinput.txt"
// let NUM_LINES = 5
// let target = 127

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

        var index = 0
        var upperBound = index + 2 // Minimum 2 numbers

        var resultArr = [Int]()
        while index < lines.count {
            
            while upperBound < lines.count {
                let arr = Array(lines[index..<upperBound])
                let sum = arr.reduce(0){ $0 + $1 }
                if sum == target {
                    resultArr = arr
                    break
                }
                upperBound += 1
            }
            index += 1
            upperBound = index + 2
            
        }
        print("resultArr: ", resultArr)
        print("Result: ", resultArr.min()! + resultArr.max()!)
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}