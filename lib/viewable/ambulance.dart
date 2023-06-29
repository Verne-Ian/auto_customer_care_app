
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

  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {

      try {
        firestore.collection('ambulance_requests').add({
          'name': currentUser?.displayName,
          'location': _locationController.text,
          'contact': _contactController.text,
          'status': 'Ongoing',
          'timestamp': FieldValue.serverTimestamp(),
        }).then((value){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ambulance request submitted!'),
              backgroundColor: Colors.green,
            ),
          );
        }).onError((error, stackTrace){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Failed to submit ambulance request. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Failed to submit ambulance request. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }

    }
  }

  Future<void> cancel(String docId) async {
    try {
      await firestore.collection('ambulance_requests').doc(docId).delete().then((value){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ambulance request canceled.'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final appBar = AppBar(
      title: const Text('Ambulance Request from',
          style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.green,
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('ambulance_requests')
            .where('name', isEqualTo: currentUser?.displayName)
            .where('status', isEqualTo: 'Ongoing')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final requests = snapshot.data!.docs;
            if (requests.isNotEmpty) {
              // User has pending or ongoing requests
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index].data() as Map<String, dynamic>;
                  final status = request['status'] ?? '';
                  final location = request['location'] ?? '';
                  final contact = request['contact'] ?? '';
                  final docId = requests[index].id;

                  return Center(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Request: $status'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Location: $location'),
                                Text('Contact: $contact'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                // Cancel button action
                                cancel(docId);
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }

          // Display the form when there are no pending or ongoing requests
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '${currentUser?.displayName}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
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
                          onPressed: _submitRequest,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.black26;
                                }
                                return Colors.green;
                              }),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                          child: const Text('Request'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}