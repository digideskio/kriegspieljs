describe("Board", function() {
  var board;
  beforeEach(function () {
    // var Board = require('board');
    board = new Board();
  });
  
  describe("#pieceType", function() {
    it("should be undefined when unoccupied", function() {
      for (var i = 0; i < 8; i++) {
        for (var j = 2; j < 6; j++) {
          expect(board.pieceType(i, j)).toBe(undefined);
        }
      }
    });
    it("should be 1 for pawns", function() {
      expect(board.pieceType(0, 1)).toBe(1);
      expect(board.pieceType(0, 6)).toBe(1);
    });
    it("should be 2 for knights", function() {
      expect(board.pieceType(1, 0)).toBe(2);
      expect(board.pieceType(1, 7)).toBe(2);
    });
    it("should be 3 for bishops", function() {
      expect(board.pieceType(2, 0)).toBe(3);
      expect(board.pieceType(2, 7)).toBe(3);
    });
    it("should be 4 for rooks", function() {
      expect(board.pieceType(0, 0)).toBe(4);
      expect(board.pieceType(0, 7)).toBe(4);
    });
    it("should be 5 for queens", function() {
      expect(board.pieceType(3, 0)).toBe(5);
      expect(board.pieceType(3, 7)).toBe(5);
    });
    it("should be 6 for kings", function() {
      expect(board.pieceType(4, 0)).toBe(6);
      expect(board.pieceType(4, 7)).toBe(6);
    });
  });
  
  describe("#color", function() {
    it("should be positive for white pieces", function() {
      for (var i = 0; i < 8; i++) {
        expect(board.color(i, 0)).toBeGreaterThan(0);
        expect(board.color(i, 1)).toBeGreaterThan(0);
      }
    });
    it("should be negative for black pieces", function() {
      for (var i = 0; i < 8; i++) {
        expect(board.color(i, 6)).toBeLessThan(0);
        expect(board.color(i, 7)).toBeLessThan(0);
      }
    });
    it("should be undefined for unoccupied spaces", function() {
      for (var i = 0; i < 8; i++) {
        for (var j = 2; j < 6; j++) {
          expect(board.color(i, j)).toBe(undefined);
        }
      }
    });
  });
  
  describe("a piece", function() {
    it("can't move off the board", function() {
      expect(board.canMove(0, 0, 0, -1)).toBeFalsy();
    });
    it("can't capture a piece of the same color", function() {
      expect(board.canMove(4, 0, 4, 1)).toBeFalsy();
      board.move(4, 1, 4, 3);
      expect(board.canMove(4, 0, 4, 1)).toBeTruthy();
    });
  });
  
  describe("a pawn", function() {
    it("should be able to advance twice from homerow", function() {
      expect(board.canMove(0, 1, 0, 3)).toBeTruthy();
      expect(board.canMove(0, 6, 0, 4)).toBeTruthy();
    });
    it("shouldn't be able to advance twice if not on the homerow", function() {
      board.forceMove(0, 1, 3, 3);
      expect(board.canMove(3, 3, 3, 5)).toBeFalsy();
    });
    it("should be able to advance once from anywhere", function() {
      expect(board.canMove(0, 1, 0, 2)).toBeTruthy();
      expect(board.canMove(0, 6, 0, 5)).toBeTruthy();
      board.forceMove(0, 1, 3, 3);
      expect(board.canMove(3, 3, 3, 4)).toBeTruthy();
    });
    it("shouldn't be able to advance onto another piece", function() {
      board.forceMove(0, 1, 0, 5);
      expect(board.canMove(0, 5, 0, 6)).toBeFalsy();
    });
  });
  
  describe("a knight", function() {
    it("moves in an L shape", function() {
      board.forceMove(1, 0, 4, 4);
      expect(board.canMove(4, 4, 5, 2)).toBeTruthy();
      expect(board.canMove(4, 4, 5, 6)).toBeTruthy();
      expect(board.canMove(4, 4, 6, 3)).toBeTruthy();
      expect(board.canMove(4, 4, 6, 5)).toBeTruthy();
      expect(board.canMove(4, 4, 3, 2)).toBeTruthy();
      expect(board.canMove(4, 4, 3, 6)).toBeTruthy();
      expect(board.canMove(4, 4, 2, 3)).toBeTruthy();
      expect(board.canMove(4, 4, 2, 5)).toBeTruthy();
    });
  });
  
  // describe("a bishop", function() {
  //   it("moves on the diagonals", function() {
  //     board.forceMove(2, 0, 4, 4);
  //     expect(board.canMove(4, 4, 2, 2)).toBeTruthy();
  //     expect(board.canMove(4, 4, 2, 6)).toBeTruthy();
  //     expect(board.canMove(4, 4, 3, 3)).toBeTruthy();
  //     expect(board.canMove(4, 4, 3, 5)).toBeTruthy();
  //     expect(board.canMove(4, 4, 5, 5)).toBeTruthy();
  //     expect(board.canMove(4, 4, 5, 3)).toBeTruthy();
  //     expect(board.canMove(4, 4, 6, 6)).toBeTruthy();
  //     expect(board.canMove(4, 4, 6, 2)).toBeTruthy();
  //   });
  //   it("can't jump over pieces", function() {
  //     board.forceMove(2, 0, 5, 5);
  //     expect(board.canMove(5, 5, 2, 2)).toBeTruthy();
  //     board.move(4, 6, 4, 4);
  //     expect(board.canMove(5, 5, 2, 2)).toBeFalsy();
  //   });
  // });
  describe("a rook", function() {
    // it("moves on the rows/columns", function() {
    //   board.forceMove(0, 0, 4, 4);
    //   expect(board.canMove(4, 4, 0, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 1, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 2, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 3, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 5, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 6, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 7, 4)).toBeTruthy();
    //   expect(board.canMove(4, 4, 4, 2)).toBeTruthy();
    //   expect(board.canMove(4, 4, 4, 3)).toBeTruthy();
    //   expect(board.canMove(4, 4, 4, 5)).toBeTruthy();
    //   expect(board.canMove(4, 4, 4, 6)).toBeTruthy();
    // });
    it("can't jump over pieces", function() {
      board.forceMove(0, 0, 4, 4);
      expect(board.canMove(4, 4, 0, 4)).toBeTruthy();
      board.move(3, 6, 3, 4);
      expect(board.canMove(4, 4, 0, 4)).toBeFalsy();
    });
  });
});