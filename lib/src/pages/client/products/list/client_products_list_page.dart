
import 'package:delivery_project/src/models/category.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {

  ClientProductsListController _con = new ClientProductsListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          // Le da un tamaño al appbar
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            // Aqui pensonalizamos
            actions: [
              _shopingBar()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox( height: 80),
                _menuDrawer(),
                SizedBox( height: 15),
                _textFieldSearch()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index){
                // CREAMOS UN CONTAINER
                return Tab(
                  child: Text(_con.categories[index].name ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children:_con.categories.map((Category category){
              return FutureBuilder(
                future: _con.getProducts(category.id),
                builder: (context, AsyncSnapshot<List<Product>> snapshot){

                  if(snapshot.hasData){
                    if (snapshot.data.length > 0){
                      return GridView.builder( padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75
                      ), itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index ){
                            return _cardProduct( snapshot.data[index]);
                          });
                    }else{
                      return NoDataWidget( text:'No hay elementos en esta categoria');
                    }
                  }else{
                    return NoDataWidget( text:'No hay elementos en esta categoria');
                  }
                },
              );
            }).toList()
          ,
        )
      ),
    );
  }

  
  Widget _cardProduct(Product product){
    return GestureDetector(
      onTap: (){
        _con.openBottomSheet(product);
      },
      child: Container(
        height   : 250,
        child : Card(
          elevation : 3,
          shape :  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ) ,
          child: Stack(
            children: [
              Positioned(
                  top :  -1.0,
                  right: -1.0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(20)
                      )
                    ),
                    child: Icon(Icons.add , color: Colors.white,),
                  )
              ) ,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top:12),
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: EdgeInsets.all(20),
                    child: FadeInImage(
                      image: product.image1 != null ? NetworkImage(product.image1) : AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  ) ,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 33,
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'NimbusSans'
                      ),
                    ),
                  ) ,
                  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
                    child: Text(
                      '\$ ${product.price ??  0}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans'
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _shopingBar(){
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15, top: 13),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: MyColors.primaryColor,
            ),
          ),
          Positioned(
              right: 16,
              top: 15,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _textFieldSearch(){
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(Icons.search, color: MyColors.primaryColor,),
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 17
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
          contentPadding: EdgeInsets.all(15)
        ),
      ),
    );
  }

  // Este es el boton para actiar el draweer
  Widget _menuDrawer(){
    return GestureDetector(
      onTap: (){
        _con.openDrawer();
      },
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png' , width: 20, height: 20, color: Colors.black,),
      ),
    );
  }
  
  Widget _drawer(){
    return Drawer(
      // Se posicionaran uno debajo del otro
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ _con.user?.name ?? ''} ${ _con.user?.lastname ?? ''} ',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    // Solo puede tener una linea el texto
                    maxLines: 1,
                  ),
                  // Aqui va el correo electronico
                  Text(
                    '${ _con.user?.email ?? '' }',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    // Solo puede tener una linea el texto
                    maxLines: 1,
                  ),
                  Text(
                    '${_con.user?.phone ??  ''}',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    // Solo puede tener una linea el texto
                    maxLines: 1,
                  ) ,
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _con.user?.image != null
                      ? NetworkImage(_con.user?.image)
                      : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder:AssetImage('assets/img/no-image.png') ,
                    ),
                  ) ,
                ],
              )
          ) ,
          ListTile(
            onTap: _con.goToUpdatePage,
            title: Text('Editar Perfil'),
            trailing: Icon(Icons.edit_outlined),
          ),
          ListTile(
            onTap: _con.goToOrdersList,
            title: Text('Mis Pedidos'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ),
          _con.user != null ?
          _con.user.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Cambiar Rol'),
            trailing: Icon(Icons.person_outline),
          ) : Container() : Container(),
          ListTile(
            title: Text('Cerrar Sesión'),
            trailing: Icon(Icons.power_settings_new_outlined),
            onTap: _con.logout,
          ),
        ],
      ),
    );
  }

  void refresh(){
    setState(() {
    });
  }

}
