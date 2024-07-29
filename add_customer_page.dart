import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'models.dart';  // Ensure this import is here
import 'actions.dart';
import 'api_service.dart';

class AddCustomerPage extends StatefulWidget {
  static const routeName = '/add-customer';

  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final List<Address> _addresses = [];

  @override
  void dispose() {
    _panController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _verifyPAN() async {
    final pan = _panController.text;
    if (pan.isNotEmpty) {
      final response = await ApiService.verifyPAN(pan);
      if (response['isValid']) {
        _fullNameController.text = response['fullName'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid PAN')),
        );
      }
    }
  }

  Future<void> _getPostcodeDetails(String postcode, int index) async {
    final response = await ApiService.getPostcodeDetails(postcode);
    setState(() {
      _addresses[index].city = response['city'][0]['name'];
      _addresses[index].state = response['state'][0]['name'];
    });
  }

  void _addAddress() {
    setState(() {
      if (_addresses.length < 10) {
        _addresses.add(Address(line1: '', postcode: '', state: '', city: ''));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum 10 addresses allowed')),
        );
      }
    });
  }

  void _saveCustomer() {
    if (_formKey.currentState?.validate() ?? false) {
      final customer = Customer(
        pan: _panController.text,
        fullName: _fullNameController.text,
        email: _emailController.text,
        mobileNumber: _mobileController.text,
        addresses: _addresses,
      );
      StoreProvider.of<List<Customer>>(context).dispatch(AddCustomerAction(customer));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _panController,
                decoration: InputDecoration(labelText: 'PAN'),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'PAN is required';
                  }
                  final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                  if (!panRegex.hasMatch(value)) {
                    return 'Invalid PAN format';
                  }
                  return null;
                },
                onChanged: (value) {
                  _verifyPAN();
                },
              ),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                maxLength: 140,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                maxLength: 255,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number', prefixText: '+91 '),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile Number is required';
                  }
                  if (value.length != 10) {
                    return 'Mobile Number must be 10 digits';
                  }
                  final mobileRegex = RegExp(r'^[0-9]{10}$');
                  if (!mobileRegex.hasMatch(value)) {
                    return 'Invalid mobile number';
                  }
                  return null;
                },
              ),
              ..._addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                return Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address Line 1'),
                      onChanged: (value) {
                        address.line1 = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address Line 1 is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Address Line 2'),
                      onChanged: (value) {
                        address.line2 = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Postcode'),
                      onChanged: (value) {
                        address.postcode = value;
                        if (value.length == 6 && RegExp(r'^[0-9]+$').hasMatch(value)) {
                          _getPostcodeDetails(value, index);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Postcode is required';
                        }
                        if (value.length != 6) {
                          return 'Postcode must be 6 digits';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Postcode must be a number';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'State'),
                      value: address.state.isNotEmpty ? address.state : null,
                      items: [
                        // Add items here, this example assumes these values
                        DropdownMenuItem(value: 'Maharashtra', child: Text('Maharashtra')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          address.state = value ?? '';
                        });
                      },
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'City'),
                      value: address.city.isNotEmpty ? address.city : null,
                      items: [
                        // Add items here, this example assumes these values
                        DropdownMenuItem(value: 'Pune', child: Text('Pune')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          address.city = value ?? '';
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
              TextButton(
                onPressed: _addAddress,
                child: Text('Add Address'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text('Save Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
