import 'package:barter_system/View/Screens/Main%20Screens/add_product.dart';
import 'package:barter_system/View/Screens/Main%20Screens/chat_screen.dart';
import 'package:barter_system/linker.dart';
import 'package:flutter/cupertino.dart';

class NavBar extends StatefulWidget {
  int? selectedIndex;
   NavBar({super.key,this.selectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex =  0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
  }

  final List<Widget> _pages = [
    HomePage(),
    AddProduct(),
    ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GNav(
              rippleColor:
                  MyColors.secondary, // tab button ripple color when pressed
              hoverColor: Colors.grey, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                  color: MyColors.secondary, width: 1), // tab button border
              curve: Curves.easeInToLinear, // tab animation curves
              duration:
                  const Duration(milliseconds: 600), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Theme.of(context)
                  .colorScheme
                  .tertiary, // unselected icon color
              iconSize: 20,
              backgroundColor: Theme.of(context).colorScheme.background,
              tabBackgroundColor: MyColors.secondary,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15), // navigation bar padding
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: const [
                GButton(
                  icon: CupertinoIcons.house_fill,
                  text: 'Home',
                ),
                GButton(
                  icon: CupertinoIcons.add_circled_solid,
                  text: 'Add',
                ),
                GButton(
                  icon: CupertinoIcons.chat_bubble_2_fill,
                  text: 'Messages',
                ),
                GButton(
                  icon: CupertinoIcons.person_solid,
                  text: 'Profile',
                )
              ]),
        ),
      ),
    );
  }
}
