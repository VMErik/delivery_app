import 'dart:ffi';

import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/utils/relative_time_util.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({Key key}) : super(key: key);

  @override
  _ClientOrdersListPageState createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage> {

  ClientOrdersListController _con = new ClientOrdersListController();

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
              title: Text('Mis pedidos'),
              automaticallyImplyLeading: false,
              backgroundColor: MyColors.primaryColor,
              bottom: TabBar(
                indicatorColor: MyColors.primaryColor,
                labelColor: Colors.white,
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
                              'Repartidor : ${order.delivery?.name ?? '--NO ASIGNADO--'}  ${order.delivery?.lastname ?? ''} ',
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


  void refresh(){
    setState(() {
    });
  }
}
