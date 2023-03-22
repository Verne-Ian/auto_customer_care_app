import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainSideBar extends StatefulWidget {
  const MainSideBar({Key? key}) : super(key: key);

  @override
  State<MainSideBar> createState() => _MainSideBarState();
}

class _MainSideBarState extends State<MainSideBar> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Drawer(
      width: w*0.85,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.network('${FirebaseAuth.instance.currentUser?.photoURL}',
                fit: BoxFit.cover,
                width: 90,
                height: 60,)),
            ),
              accountName: Text('${FirebaseAuth.instance.currentUser?.displayName}'),
              accountEmail: Text('${FirebaseAuth.instance.currentUser?.email}'),
            ),
          const ListTile(
            leading: Icon(Icons.feedback,
              size: 20.0,),
            title: Text('Support',
              style: TextStyle(
                  fontSize: 15.0
              ),),
            onTap: null,
          ),
          ListTile(
              leading: const Icon(Icons.logout,
                size: 20.0,),
              title: const Text('Log Out',
                style: TextStyle(
                    fontSize: 15.0
                ),),
              onTap: (){
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.pushReplacementNamed(context, '/login');
                });
              }
          ),
          ListTile(
            leading: const Icon(Icons.close_outlined,
                size: 20.0),
            title: const Text('Exit App',
              style: TextStyle(
                  fontSize: 15.0
              ),),
            onTap: (){SystemNavigator.pop();},
          )
        ],
      ),
    );
  }
}
