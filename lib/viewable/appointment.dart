import 'package:auto_customer_care/services/MainServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jap_icons/medical_icons_icons.dart';


class AppointmentForm extends StatefulWidget {
  const AppointmentForm({Key? key}) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {

        firestore.collection('appointments').add({
          'name': currentUser?.displayName,
          'phone': _phoneController.text,
          'service': _serviceController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'status': 'Pending',
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment request submitted!'),
              backgroundColor: Colors.green,
            ),
          );
          _serviceController.text = 'Select Service';
          _phoneController.clear();
          _dateController.text = 'Select Date';
          _timeController.clear();
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit appointment request. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit appointment request. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  Future<void> cancel(String docId) async {
    try {
      await firestore.collection('appointments').doc(docId).delete().then((value){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment canceled.'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel appointment request.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formattedTime = picked.format(context);
      setState(() {
        _timeController.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Make Appointment'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('appointments')
            .where('name', isEqualTo: currentUser?.displayName)
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final appointments = snapshot.data!.docs;
            if (appointments.isNotEmpty) {
              // User has pending or ongoing requests
              return ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index].data() as Map<String, dynamic>;
                  final status = appointment['status'] ?? '';
                  final service = appointment['service'] ?? '';
                  final date = appointment['date'] ?? '';
                  final time = appointment['time'] ?? '';
                  final docId = appointments[index].id;

                  return Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3,
                        left: 8.0, right: 8.0,
                    bottom: MediaQuery.of(context).size.height * 0.3),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  opacity: 0.9,
                                  image: AssetImage("assets/images/health-clinic.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Appointment Status: $status'),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Service: $service'),
                                Text('Date: $date'),
                                Text('Time: $time'),
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
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.black26;
                                      }
                                      return Colors.green;
                                    }),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            readOnly: true,
                            controller: _serviceController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Service',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the service';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: (){
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context){
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0))
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.medical_services),
                                            title: const Text('Doctor'),
                                            onTap: (){
                                              _serviceController.text = 'Doctor';
                                              Navigator.pop(context);},
                                          ),
                                          ListTile(
                                            leading: const Icon(MedicalIcons.pediatrics),
                                            title: const Text('Pediatrician'),
                                            onTap: (){
                                              _serviceController.text = 'Pediatrician';
                                              Navigator.pop(context);},
                                          ),
                                          ListTile(
                                            leading: const Icon(MedicalIcons.dental),
                                            title: const Text('Dentist'),
                                            onTap: (){
                                              _serviceController.text = 'Dentist';
                                              Navigator.pop(context);},
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.change_circle)),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        AllServices.selectDate(setState, context, _dateController);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dateController.text.isEmpty
                                  ? 'Select Date'
                                  : _dateController.text,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: _timeController,
                          decoration: const InputDecoration(
                            labelText: 'Appointment Time',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the appointment time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black26;
                            }
                            return Colors.green;
                          }),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
