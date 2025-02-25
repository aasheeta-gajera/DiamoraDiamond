import 'package:flutter/material.dart';

import '../Authentication/AuthChoiceScreen.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  icon: Icons.person,
                  text: "Profile",
                  iconColor: Colors.pink[400]!,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.home,
                  text: "Home",
                  iconColor: Colors.blue[400]!,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart_checkout,
                  text: "My Cart",
                  iconColor: Colors.purple[400]!,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.receipt_long,
                  text: "Orders",
                  iconColor: Colors.green[400]!,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  text: "Wishlist",
                  iconColor: Colors.red[400]!,
                  onTap: () {},
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  text: "Settings",
                  iconColor: Colors.orange[400]!,
                  onTap: () {},
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  text: "Logout",
                  iconColor: Colors.redAccent,
                  onTap: () {
                    // // Implement logout logic
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthChoiceScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
       color: Colors.green[100]!
      ),
      child: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Color(0xFF2575FC)),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "User Name",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "user@example.com",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

}

