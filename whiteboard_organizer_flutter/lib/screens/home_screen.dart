import 'package:flutter/material.dart';
import 'package:whiteboard_organizer_flutter/tabs/home_tab.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("Pagina Inicial"),
            centerTitle: true,
            actions: [
              
            ],
          ),
          body: HomeTab(_pageController),
          // drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Escolha um fornecedor"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            // onPressed: () {
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(builder: (context) => CartScreen()));
            // },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.shopping_cart_outlined,
            ),
            elevation: 4,
          ),
          // body: SupplierTab(),
          // drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          // body: OrderTab(),
          // drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configurações"),
            centerTitle: true,
          ),
          body: Center(child: Text("TO-DO"),),
          // drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}