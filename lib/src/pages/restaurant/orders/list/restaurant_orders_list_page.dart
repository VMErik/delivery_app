import 'package:delivery_project/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({Key key}) : super(key: key);

  @override
  _RestaurantOrdersListPageState createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {

  RestaurantOrdersListController _con = new RestaurantOrdersListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context , refresh);
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
            preferredSize: Size.fromHeight(100),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              // Aqui pensonalizamos
              flexibleSpace: Column(
                children: [
                  _menuDrawer(),
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
                    child: Text(_con.categories[index] ?? ''),
                  );
                }),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
            children:_con.categories.map((String category){
              return Container();
              // return FutureBuilder(
              //   future: _con.getProducts(category.id),
              //   builder: (context, AsyncSnapshot<List<Product>> snapshot){
              //
              //     if(snapshot.hasData){
              //       if (snapshot.data.length > 0){
              //         return GridView.builder( padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             childAspectRatio: 0.75
              //         ), itemCount: snapshot.data?.length ?? 0,
              //             itemBuilder: (_, index ){
              //               return _cardProduct( snapshot.data[index]);
              //             });
              //       }else{
              //         return NoDataWidget( text:'No hay elementos en esta categoria');
              //       }
              //     }else{
              //       return NoDataWidget( text:'No hay elementos en esta categoria');
              //     }
              //   },
              //);
            }).toList()
            ,
          )
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
        margin: EdgeInsets.only(left: 20 , top: 80),
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
            title: Text('Crear Categoria'),
            trailing: Icon(Icons.list_alt),
            onTap: _con.goToCategoryCreate,
          ),
          ListTile(
            title: Text('Crear Producto'),
            trailing: Icon(Icons.local_pizza),
            onTap: _con.goToProductCreate,
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
