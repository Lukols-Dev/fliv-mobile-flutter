/// Domain-level errors for assigning a transport order to the current driver.
/// The repository layer translates HTTP failures into these so the UI doesn't
/// need to inspect Dio/HTTP details.
sealed class AssignOrderException implements Exception {
  const AssignOrderException();
}

/// No transport order matches the given ZT number.
class OrderNotFoundException extends AssignOrderException {
  const OrderNotFoundException();
}

/// The order is already assigned to a different driver.
class OrderAlreadyAssignedException extends AssignOrderException {
  const OrderAlreadyAssignedException();
}
