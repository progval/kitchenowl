import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchenowl/cubits/recipe_list_cubit.dart';
import 'package:kitchenowl/cubits/shoppinglist_cubit.dart';
import 'package:kitchenowl/enums/update_enum.dart';
import 'package:kitchenowl/pages/recipe_add_update_page.dart';
import 'package:kitchenowl/pages/home_page/home_page.dart';
import 'package:kitchenowl/kitchenowl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ShoppinglistCubit shoppingListCubit = ShoppinglistCubit();
  final RecipeListCubit recipeListCubit = RecipeListCubit();

  List<Widget> pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      BlocProvider.value(value: shoppingListCubit, child: ShoppinglistPage()),
      BlocProvider.value(value: recipeListCubit, child: RecipeListPage()),
      ProfilePage(),
    ];
  }

  @override
  void dispose() {
    shoppingListCubit.close();
    recipeListCubit.close();
    super.dispose();
  }

  void _onItemTapped(int i) {
    if (i == 0 && _selectedIndex != i) {
      shoppingListCubit.refresh();
    }
    if (i == 1 && _selectedIndex != i) {
      recipeListCubit.refresh();
    }
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: pages[_selectedIndex],
      ),
      floatingActionButton: [
        null,
        FloatingActionButton(
          onPressed: () async {
            final res = await Navigator.of(context).push<UpdateEnum>(
                MaterialPageRoute(builder: (context) => AddUpdateRecipePage()));
            if (res == UpdateEnum.updated) {
              recipeListCubit.refresh();
            }
          },
          child: Icon(Icons.add),
        ),
        null,
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: AppLocalizations.of(context).shoppingList,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: AppLocalizations.of(context).recipes,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context).profile,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
