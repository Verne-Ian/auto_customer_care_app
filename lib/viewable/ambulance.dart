import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AmbulanceRequestPage extends StatefulWidget {
  const AmbulanceRequestPage({super.key});

  @override
  _AmbulanceRequestPageState createState() => _AmbulanceRequestPageState();
}

class _AmbulanceRequestPageState extends State<AmbulanceRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final contact = _contactController.text;
      final location = _locationController.text;

      final ambulanceRequest = {
        'name': name,
        'location': location,
        'contact': contact,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('ambulance_requests')
          .add(ambulanceRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ambulance request submitted!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final appBar = AppBar(
      title: const Text('Ambulance Request'),
      backgroundColor: Colors.black54,
    );
    final formHeight = screenHeight -
        appBar.preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom -
        16.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Request an ambulance',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${FirebaseAuth.instance.currentUser?.displayName}';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the patient's location";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _contactController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter caretaker's contact";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (){
                          _submitRequest;
                          //_nameController.clear();
                          _locationController.clear();
                          _contactController.clear();
                          },
                        child: const Text('Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}