import React, { PropTypes } from 'react';
import { DragSource } from 'react-dnd';

function character(props) {
  let {pieceType, color} = props;
  let isWhite = color > 0;
  switch (pieceType) {
    case 1: // PAWN
      return isWhite ? '♙' : '♟';
    case 2: // KNIGHT
      return isWhite ? '♘' : '♞';
    case 3: // BISHOP
      return isWhite ? '♗' : '♝';
    case 4: // ROOK
      return isWhite ? '♖' : '♜';
    case 5: // QUEEN
      return isWhite ? '♕' : '♛';
    case 6: // KING
      return isWhite ? '♔' : '♚';
  }
}

const spec = {
  beginDrag(props) {
    return {x: props.x, y: props.y};
  },
  canDrag(props) {
    return props.canDrag(props.color);
  }
};

function collect(connect, monitor) {
  return {
    connectDragSource: connect.dragSource(),
    isDragging: monitor.isDragging()
  }
}

class Piece extends React.Component {
  render() {
    const { connectDragSource, isDragging } = this.props;
    return connectDragSource(
      <a style={{opacity: isDragging ? 0.5 : 1}}>{character(this.props)}</a>
    );
  }
}

export default DragSource('piece', spec, collect)(Piece);

Piece.propTypes = {
  connectDragSource: PropTypes.func.isRequired,
  isDragging: PropTypes.bool.isRequired
};

// export class Pawn extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♙' : '♟';
//   }
// }

// export class Knight extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♘' : '♞';
//   }
// }

// export class Bishop extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♗' : '♝';
//   }
// }

// export class Rook extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♖' : '♜';
//   }
// }

// export class Queen extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♕' : '♛';
//   }
// }

// export class King extends Piece {
//   constructor(props) {
//     super(props);
//     let isWhite = props.color > 0;
//     this.piece = isWhite ? '♔' : '♚';
//   }
// }