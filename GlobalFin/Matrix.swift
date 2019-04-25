import Accelerate

public struct Matrix {
    
    public var data: [Double]
    public let width: Int
    public let height: Int
    
    public init(rowMajorData: [Double], width: Int) {
        precondition(rowMajorData.count % width == 0)
        
        data = rowMajorData
        self.width = width
        self.height = rowMajorData.count / width
    }
    
    public init(_ rows: [[Double]]) {
        height = rows.count
        if height > 0 {
            width = rows[0].count
        } else {
            width = 0
        }
        
        data = []
        for r in rows {
            assert(r.count == width)
            data.append(contentsOf: r)
        }
    }
}
