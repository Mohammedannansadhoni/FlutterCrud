import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'reducers.dart';
import 'models.dart';

final store = Store<List<Customer>>(
  customerReducer,
  initialState: [],
);
