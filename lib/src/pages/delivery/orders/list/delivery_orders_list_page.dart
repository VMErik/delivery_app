
import 'package:delivery_project/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({Key key}) : super(key: key);

  @override
  _DeliveryOrdersListPageState createState() => _DeliveryOrdersListPageState();
}

class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {


  DeliverOrdersListController _con = new DeliverOrdersListController();

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
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        child: Text('Deliery Order List'),
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
        child: Image.asset('assets/img/menu.png' , width: 20, height: 20, color: Colors.white,),
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
                    image: AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder:AssetImage('assets/img/no-image.png') ,
                  ),
                ) ,
              ],
            )
        ) ,
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
