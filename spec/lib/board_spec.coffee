describe "Board", ->
  board = undefined
  onForcedMove = jasmine.createSpy()
  beforeEach ->
    Board = require("../../lib/Board")
    board = new Board(onForcedMove: onForcedMove)
  
  describe "#pieceType", ->
    it "should be undefined when unoccupied", ->
      for i in [0...8]
        for j in [2...6]
          expect(board.pieceType(i, j)).toBe undefined
    
    it "should be 1 for pawns", ->
      expect(board.pieceType(0, 1)).toBe 1
      expect(board.pieceType(0, 6)).toBe 1
    
    it "should be 2 for knights", ->
      expect(board.pieceType(1, 0)).toBe 2
      expect(board.pieceType(1, 7)).toBe 2
    
    it "should be 3 for bishops", ->
      expect(board.pieceType(2, 0)).toBe 3
      expect(board.pieceType(2, 7)).toBe 3
    
    it "should be 4 for rooks", ->
      expect(board.pieceType(0, 0)).toBe 4
      expect(board.pieceType(0, 7)).toBe 4
    
    it "should be 5 for queens", ->
      expect(board.pieceType(3, 0)).toBe 5
      expect(board.pieceType(3, 7)).toBe 5
    
    it "should be 6 for kings", ->
      expect(board.pieceType(4, 0)).toBe 6
      expect(board.pieceType(4, 7)).toBe 6
  
  describe "#color", ->
    it "should be positive for white pieces", ->
      for i in [0...8]
        expect(board.color(i, 0)).toBeGreaterThan 0
        expect(board.color(i, 1)).toBeGreaterThan 0
    
    it "should be negative for black pieces", ->
      for i in [0...8]
        expect(board.color(i, 6)).toBeLessThan 0
        expect(board.color(i, 7)).toBeLessThan 0
    
    it "should be undefined for unoccupied spaces", ->
      for i in [0...8]
        for j in [2...6]
          expect(board.color(i, j)).toBe undefined
  
  describe "a piece", ->
    it "can't move off the board", ->
      expect(board.canMove(0, 0, 0, -1)).toBeFalsy()
    
    it "can't capture a piece of the same color", ->
      expect(board.canMove(4, 0, 4, 1)).toBeFalsy()
      board.forceMove 4, 1, 4, 3
      expect(board.canMove(4, 0, 4, 1)).toBeTruthy()
    
    it "can't be moved if it's not that piece's turn", ->
      expect(board.canMove(0, 6, 0, 5)).toBeFalsy()
      expect(board.move(0, 1, 0, 3)).toBeTruthy()
      expect(board.canMove(0, 6, 0, 5)).toBeTruthy()
  
  describe "a pawn", ->
    it "should be able to advance twice from homerow", ->
      expect(board.canMove(0, 1, 0, 3)).toBeTruthy()
      board.move 0, 1, 0, 3 # advance turn
      expect(board.canMove(0, 6, 0, 4)).toBeTruthy()
    
    it "shouldn't be able to advance twice if not on the homerow", ->
      board.forceMove 0, 1, 3, 3
      expect(board.canMove(3, 3, 3, 5)).toBeFalsy()
    
    it "should be able to advance once from anywhere", ->
      expect(board.canMove(0, 1, 0, 2)).toBeTruthy()
      board.move 0, 1, 0, 2 # advance turn
      expect(board.canMove(0, 6, 0, 5)).toBeTruthy()
      board.move 0, 6, 0, 5 # advance turn
      board.forceMove 0, 2, 3, 3
      expect(board.canMove(3, 3, 3, 4)).toBeTruthy()
    
    it "shouldn't be able to advance onto another piece", ->
      board.forceMove 0, 1, 0, 5
      expect(board.canMove(0, 5, 0, 6)).toBeFalsy()
  
  describe "a knight", ->
    it "moves in an L shape", ->
      board.forceMove 1, 0, 4, 4
      expect(board.canMove(4, 4, 5, 2)).toBeTruthy()
      expect(board.canMove(4, 4, 5, 6)).toBeTruthy()
      expect(board.canMove(4, 4, 6, 3)).toBeTruthy()
      expect(board.canMove(4, 4, 6, 5)).toBeTruthy()
      expect(board.canMove(4, 4, 3, 2)).toBeTruthy()
      expect(board.canMove(4, 4, 3, 6)).toBeTruthy()
      expect(board.canMove(4, 4, 2, 3)).toBeTruthy()
      expect(board.canMove(4, 4, 2, 5)).toBeTruthy()
  
  describe "a bishop", ->
    it "moves on the diagonals", ->
      canMoveLikeBishop 2, 0
    
    it "can't jump over pieces", ->
      board.forceMove 2, 0, 5, 5
      expect(board.canMove(5, 5, 2, 2)).toBeTruthy()
      board.forceMove 4, 6, 4, 4
      expect(board.canMove(5, 5, 2, 2)).toBeFalsy()
  
  describe "a rook", ->
    it "moves on the rows/columns", ->
      canMoveLikeRook 0, 0
    
    it "can't jump over pieces", ->
      board.forceMove 0, 0, 4, 4
      expect(board.canMove(4, 4, 0, 4)).toBeTruthy()
      board.forceMove 3, 6, 3, 4
      expect(board.valueAt(3,4)).toBe -1
      expect(board.canMove(4, 4, 0, 4)).toBeFalsy()
    
  describe "a queen", ->
    it "can move like a rook on rows/columns", ->
      canMoveLikeRook 3, 0
    it "can move like a bishop on the diagonals", ->
      canMoveLikeBishop 3, 0
    
    it "can't jump over pieces", ->
      board.forceMove 3, 0, 4, 4
      expect(board.canMove(4, 4, 0, 4)).toBeTruthy()
      board.forceMove 3, 6, 3, 4
      expect(board.canMove(4, 4, 0, 4)).toBeFalsy()
  
  describe "a king", ->
    it "can move one square in any direction", ->
      board.forceMove 4, 0, 4, 4
      expect(board.canMove(4, 4, 3, 3)).toBeTruthy()
      expect(board.canMove(4, 4, 4, 3)).toBeTruthy()
      expect(board.canMove(4, 4, 5, 3)).toBeTruthy()
      expect(board.canMove(4, 4, 3, 4)).toBeTruthy()
      expect(board.canMove(4, 4, 5, 4)).toBeTruthy()
      expect(board.canMove(4, 4, 3, 5)).toBeTruthy()
      expect(board.canMove(4, 4, 4, 5)).toBeTruthy()
      expect(board.canMove(4, 4, 5, 5)).toBeTruthy()
    
    it "can castle king-side", ->
      board.forceMove 5, 0, 5, 2 # move bishop out of the way
      board.forceMove 6, 0, 6, 2 # move knight out of the way
      expect(board.move(4, 0, 6, 0)).toBeTruthy()
      expect(board.valueAt(7, 0)).toBe 0
      expect(board.valueAt(5, 0)).toBe 4
      expect(onForcedMove).toHaveBeenCalledWith(7, 0, 5, 0)
    it "can't castle king-side if the king's rook has moved", ->
      board.forceMove 5, 0, 5, 2 # move bishop out of the way
      board.forceMove 6, 0, 6, 2 # move knight out of the way
      expect(board.canMove(4, 0, 6, 0)).toBeTruthy()
      board.move 7, 0, 5, 0
      board.move 0, 6, 0, 5 # advance turn
      board.move 5, 0, 7, 0
      board.move 0, 5, 0, 4 # advance turn
      expect(board.canMove(4, 0, 6, 0)).toBeFalsy()
    
    
    it "can castle queen-side", ->
      board.forceMove 1, 0, 1, 2 # move knight out of the way
      board.forceMove 2, 0, 2, 2 # move bishop out of the way
      board.forceMove 3, 0, 3, 2 # move queen out of the way
      expect(board.move(4, 0, 2, 0)).toBeTruthy()
      expect(board.valueAt(0, 0)).toBe 0
      expect(board.valueAt(3, 0)).toBe 4
      expect(onForcedMove).toHaveBeenCalledWith(0, 0, 3, 0)
    it "can't castle queen-side if the queen's rook has moved", ->
      board.forceMove 1, 0, 1, 2 # move knight out of the way
      board.forceMove 2, 0, 2, 2 # move bishop out of the way
      board.forceMove 3, 0, 3, 2 # move queen out of the way
      expect(board.canMove(4, 0, 2, 0)).toBeTruthy()
      board.move 0, 0, 1, 0
      board.move 0, 6, 0, 5 # advance turn
      expect(board.move(4, 0, 2, 0)).toBeFalsy()
  
  canMoveLikeBishop = (xOrig, yOrig) ->
    board.forceMove xOrig, yOrig, 4, 4
    expect(board.canMove(4, 4, 2, 2)).toBeTruthy()
    expect(board.canMove(4, 4, 2, 6)).toBeTruthy()
    expect(board.canMove(4, 4, 3, 3)).toBeTruthy()
    expect(board.canMove(4, 4, 3, 5)).toBeTruthy()
    expect(board.canMove(4, 4, 5, 5)).toBeTruthy()
    expect(board.canMove(4, 4, 5, 3)).toBeTruthy()
    expect(board.canMove(4, 4, 6, 6)).toBeTruthy()
    expect(board.canMove(4, 4, 6, 2)).toBeTruthy()
  
  canMoveLikeRook = (xOrig, yOrig) ->
    board.forceMove xOrig, yOrig, 4, 4
    expect(board.canMove(4, 4, 0, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 1, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 2, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 3, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 5, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 6, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 7, 4)).toBeTruthy()
    expect(board.canMove(4, 4, 4, 2)).toBeTruthy()
    expect(board.canMove(4, 4, 4, 3)).toBeTruthy()
    expect(board.canMove(4, 4, 4, 5)).toBeTruthy()
    expect(board.canMove(4, 4, 4, 6)).toBeTruthy()