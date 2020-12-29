import Foundation

class ComputeResult
{
    var a: Operand?
    var b: Operand?
    var result: String
    
    init(_ a: Operand?, _ b: Operand?, _ result: String)
    {
        self.a = a
        self.b = b
        self.result = result
    }
}

enum SearchDir
{
    case RIGHT
    case LEFT
}

class Operand
{
    var start: String.Index
    var end: String.Index
    var equation: String
    var num: String
    
    init(start: String.Index, end: String.Index, equation: String)
    {
        self.start = start
        self.end = end
        self.equation = equation
        self.num = equation.substring(with: start..<end)
    }
    
    func doubleToString(result : Double) -> String
    {
        if ceil(result) == result { return String(Int(result)) }
        else
        {
            let formatter = NumberFormatter()
            
            formatter.maximumFractionDigits = 20
            formatter.minimumFractionDigits = 0
            
            formatter.numberStyle = .decimal
            return (formatter.string(from: NSNumber(value: result)))!
        }
    }
    
    func compute(operation: Character, operand: Operand) throws -> String
    {
        let a : Double? = Double(self.num)
        let b : Double? = Double(operand.num)
        
        if a == nil || b == nil
        {
            throw NSError(domain: "Invalid operand", code: 1)
        }
        
        helpNumbers.append(a!)
        helpNumbers.append(b!)
        helpOperations.append(operation)
        
        switch operation
        {
        case "×":
            return doubleToString(result: a! * b!)
        case "÷":
            if a! == 0 || b! == 0 {
                return "0"
            } else
            if a! > b! {
                return doubleToString(result: a! / b!)
            } else {
                return doubleToString(result: b! / a!)
            }
        case "+":
            return doubleToString(result: a! + b!)
        case "-":
            return doubleToString(result: abs(a! - b!))
        default:
            return ""
        }
    }
}

class Calc
{
    var equation: String = ""
    
    static var operations: [String] = ["×", "÷", "+", "-"]
    
    func compute(str: String) throws -> ComputeResult
    {
        self.equation = str
        var right: Operand? = nil
        var left: Operand? = nil
        
        var indexOperation: String.Index? = nil
        
        while true
        {
            indexOperation = hasOperation()
            
            if indexOperation == nil { break }
            
            right = findNum(dir: .RIGHT, start: equation.index(after: indexOperation!))
            left  = findNum(dir: .LEFT, start: indexOperation!)
            
            
            if left!.num.count == 0 { break }
            
            let res: String = try left!.compute(operation: self.equation[indexOperation!], operand: right!)
            
            self.equation = String(self.equation.prefix(upTo: left!.start)) + String(res) + String(self.equation.suffix(from: right!.end))
        }
    
            return ComputeResult(right, left, self.equation)
    }
    
    func hasOperation() -> String.Index?
    {
        for i in equation.indices
        {
            if i.encodedOffset == 0 { continue }
            
            if equation[i] == "×" || equation[i] == "÷" { return i }
        }
        
        for i in equation.indices
        {
            if i.encodedOffset == 0 { continue }
            
            if equation[i] == "+" || equation[i] == "-" { return i }
        }
        
        return nil
    }
    
    func hasAnyOperation(st: String.Index, dir: SearchDir) -> String.Index?
    {
        if (dir == .RIGHT)
        {
            for i in equation.indices.suffix(from: st)
            {
                if (equation[i] == "×" || equation[i] == "÷" || equation[i] == "+" || equation[i] == "-") { return i }
            }
        }
        else
        {
            for i in equation.indices.prefix(upTo: st).reversed()
            {
                if (equation[i] == "×" || equation[i] == "÷" || equation[i] == "+" || equation[i] == "-") { return equation.index(after: i) }
            }
        }
        
        return nil
    }
    
    func findNum(dir: SearchDir, start: String.Index) -> Operand
    {
        if (dir == .RIGHT)
        {
            var nextOp = hasAnyOperation( st: equation[start] == "-" ? equation.index(after: start) : start, dir: dir )
            
            if nextOp == nil { nextOp = equation.endIndex }
            

            
            return Operand(start: start, end: nextOp!, equation : equation)
        }
        else
        {
            var prevOp = hasAnyOperation(st: start, dir: dir)
            
            if prevOp == nil && equation.first != "(" { prevOp = equation.startIndex }
            
            if prevOp == nil && equation.first == "(" { prevOp = equation.index(after: equation.startIndex )}
            
            prevOp = expandNum(dir: dir, start: prevOp!)
            
        
            return Operand(start: prevOp!, end: start, equation : equation)
            
        }
        
    }
    
    func expandNum(dir: SearchDir, start: String.Index) -> String.Index
    {
        if (dir == .LEFT && equation.startIndex != start)
        {
            if (equation[equation.index(before: start)] == "-") { return equation.index(before: start) }
        }
        
        return start
    }
}
