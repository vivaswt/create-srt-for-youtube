extension Pipe<T> on T {
  /// Passes this object as an argument to the given function [f].
  R pipe<R>(R Function(T) f) => f(this);
}
