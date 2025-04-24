/// A container object which represents a value of one of two possible types.
/// Represents a value of either type [L] or type [R], but not both.
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  /// Private constructor
  Either._internal(this._left, this._right, this._isLeft);

  /// Constructs a left value of type [L]
  factory Either.left(L value) => Either._internal(value, null, true);

  /// Constructs a right value of type [R]
  factory Either.right(R value) => Either._internal(null, value, false);

  /// Returns true if this is a left value
  bool get isLeft => _isLeft;

  /// Returns true if this is a right value
  bool get isRight => !_isLeft;

  /// Returns true if this is a failure
  bool get isFailure => _isLeft;

  /// Returns true if this is a success
  bool get isSuccess => !_isLeft;

  /// Returns the left value if this is a left, otherwise null
  L? get left => _left;

  /// Returns the right value if this is a right, otherwise null
  R? get right => _right;

  /// Returns the left value if this is a left, otherwise null.
  /// Alias for [left]
  L? get error => _left;

  /// Returns the right value if this is a right, otherwise null.
  /// Alias for [right]
  R? get data => _right;

  /// Maps this [Either] to a new [Either] with a different right type.
  Either<L, T> map<T>(T Function(R value) mapper) {
    if (isRight) {
      return Either<L, T>.right(mapper(_right as R));
    }
    return Either<L, T>.left(_left as L);
  }

  /// Handles both cases of the [Either], calling the appropriate function.
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    if (isLeft) {
      return ifLeft(_left as L);
    } else {
      return ifRight(_right as R);
    }
  }
}
