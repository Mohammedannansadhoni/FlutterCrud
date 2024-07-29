import 'models.dart';  // Ensure this import is here
import 'actions.dart';

List<Customer> customerReducer(List<Customer> state, dynamic action) {
  if (action is AddCustomerAction) {
    return List.from(state)..add(action.customer);
  } else if (action is DeleteCustomerAction) {
    return state.where((customer) => customer.pan != action.pan).toList();
  }
  return state;
}
