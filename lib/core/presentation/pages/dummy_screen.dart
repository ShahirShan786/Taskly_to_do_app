import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  final String text;

  const DummyScreen({Key? key, this.text = "Dummy Screen"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}


//  drawer: Drawer(
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(24),
//               bottomRight: Radius.circular(24),
//             ),
//           ),
//           child: Column(
//             children: [
//               const DrawerHeader(
//                 decoration: BoxDecoration(color: Colors.white),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.grey,
//                       child: Icon(Icons.person, size: 40, color: Colors.white),
//                     ),
//                     SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Shahir Mon KS",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Text(
//                           "shahir@example.com",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const ListTile(
//                 leading: Icon(Icons.home, color: Colors.black),
//                 title: Text("Home"),
//                 onTap: null,
//               ),
//               const ListTile(
//                 leading: Icon(Icons.favorite, color: Colors.black),
//                 title: Text("Favorites"),
//                 onTap: null,
//               ),
//               const ListTile(
//                 leading: Icon(Icons.settings, color: Colors.black),
//                 title: Text("Settings"),
//                 onTap: null,
//               ),
//               const Spacer(),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.logout, color: Colors.red),
//                 title:
//                     const Text("Logout", style: TextStyle(color: Colors.red)),
//                 onTap: () => showSignOutDialog(context, ref),
//               ),
//             ],
//           ),
//         ),