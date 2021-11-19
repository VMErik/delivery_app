import 'dart:ffi';

import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/utils/relative_time_util.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
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
      length: _con.status?.length,
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
                tabs: List<Widget>.generate(_con.status.length, (index){
                  // CREAMOS UN CONTAINER
                  return Tab(
                    child: Text(_con.status[index] ?? ''),
                  );
                }),
              ),
            ),
          ),
          drawer: _drawer(),
          body: TabBarView(
            children:_con.status.map((String status){
              return FutureBuilder(
                future: _con.getOrder(status),
                builder: (context, AsyncSnapshot<List<Order>> snapshot){
                  if(snapshot.hasData){
                    if (snapshot.data.length > 0){
                      return ListView.builder( padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index ){
                            return _cardOrder( snapshot.data[index]);
                          });
                    }else{
                      return NoDataWidget( text:'No hay ordenes');
                    }
                  }else{
                    return NoDataWidget( text:'No hay ordenes');
                  }
                },
              );
            }).toList()
            ,
          )
      ),
    );
  }



  Widget _cardOrder(Order order){
    return GestureDetector(
      onTap: (){
        _con.openBottonSheet(order);
      },
      child: Container(
        height : 150 ,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child : Card(
          elevation : 3.0,
          shape : RoundedRectangleBorder(
            borderRadius : BorderRadius.circular(15)
          ) ,
          child :  Stack(
            children : [
              Positioned(child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 30,
                decoration: BoxDecoration(
                  color : MyColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                ),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('Orden #${order.id}' ,
                  style: TextStyle(
                    fontSize: 15 ,
                    color: Colors.white  ,
                    fontFamily: 'NimbusSans'
                  ),),
                ),
              )),
              Container(
                margin: EdgeInsets.only(top: 40 , left: 20 , right: 20),
                child: Column(
                  children: [
                     Container(
                       alignment: Alignment.centerLeft,
                       width: double.infinity,
                       margin: EdgeInsets.symmetric(vertical: 5),
                       child: Text(
                          'Fecha del pedido : ${ RelativeTimeUtil.getRelativeTime(order?.timestamp ?? 0) }'  ,
                          style: TextStyle(
                            fontSize: 13
                          ),
                        ),
                     ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente : ${order.client.name ?? ''}  ${order.client.lastname ?? ''} ',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Entregar en : ${order.address.address}',
                        style: TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
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
