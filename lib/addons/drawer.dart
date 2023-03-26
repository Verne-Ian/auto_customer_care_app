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
                scale: 1.0,
                fit: BoxFit.cover,
                width: 100,
                height: 70,)),
            ),
              accountName: Text('${FirebaseAuth.instance.currentUser?.displayName}'),
              accountEmail: Text('${FirebaseAuth.instance.currentUser?.email}'),
            ),
          const ListTile(
            leading: Icon(Icons.feedback,
              size: 40.0,),
            title: Text('Support',
              style: TextStyle(
                  fontSize: 25.0
              ),),
            onTap: null,
          ),
          ListTile(
              leading: const Icon(Icons.logout,
                size: 40.0,),
              title: const Text('Log Out',
                style: TextStyle(
                    fontSize: 25.0
                ),),
              onTap: (){
                FirebaseAuth.instance.signOut();
              }
          ),
          ListTile(
            leading: const Icon(Icons.close_outlined,
                size: 40.0),
            title: const Text('Exit App',
              style: TextStyle(
                  fontSize: 25.0
              ),),
            onTap: (){SystemNavigator.pop();},
          )
        ],
      ),
    );
  }
}
