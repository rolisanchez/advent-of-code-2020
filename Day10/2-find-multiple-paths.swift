import Foundation

// let filepath = "./input.txt"
// let filepath = "./testinput.txt"
let filepath = "./testinput2.txt"


do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n").map{ Int($0)! }

        var dict = [0:1]
        let nums = lines.sorted()
        print(nums)
        for num in nums {
            dict[num] = dict[num-1, default: 0] + dict[num-2, default: 0] + dict[num-3, default: 0]
        }
        let ans = dict[nums.last!] ?? 0
        print(dict)
        print("ans: ", ans)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

