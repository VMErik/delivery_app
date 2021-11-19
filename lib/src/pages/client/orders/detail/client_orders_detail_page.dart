import 'package:delivery_project/src/models/order.dart';
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/models/user.dart';
import 'package:delivery_project/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/utils/relative_time_util.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'client_orders_detail_controller.dart';

class ClientOrdersDetailPage extends StatefulWidget {

  Order order;

  ClientOrdersDetailPage({Key key , @required this.order  }) : super(key: key);

  @override
  _ClientOrdersCreatePageState createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersDetailPage> {

  ClientOrdersDetailController _con = new ClientOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh , widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ORDEN # ${ _con.order?.id ?? '' }'
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(top:17 , right: 15),
            child: Text(
                '\$ ${ double.parse(_con.total.toStringAsFixed(2))  }',
                style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ))
          )
        ],
      ),
      body: _con.order?.products?.length  > 0
            ? ListView(
          children: _con.order.products.map((Product product){
            return _cardProduct(product);
          }).toList(),
      )
      : NoDataWidget(text: 'Tu bolsa de compra esta vacia'),
      // Para mandarlo al final de la pantalla
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child : SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 30, // Maregn en la parte izquierda
                indent: 30, // Margen en la parte derecha
              ),
              SizedBox(height: 10,),
              _textData('Repartidor : ' ,  '${ _con.order?.delivery?.name ?? '--NO ASIGNADO--'  } ${ _con.order?.delivery?.lastname ?? ''  }'),
              _textData('Entregar en : ' ,  '${ _con.order?.address?.address ?? ''  } ${ _con.order?.address?.neighborhood ?? ''  }'),
              _textData('Fecha Pedido : ' ,  '${ RelativeTimeUtil.getRelativeTime(_con.order?.timestamp ?? 0) }'),
              // _textTotalPrice(),
               _con.order?.status == 'EN CAMINO' ? _buttonNext() : Container()
            ],
          ),
        )
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem(List<User> users){
    List<DropdownMenuItem<String>> list  = [];
    users.forEach((user) {
      print(user);
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(top:12),
              height: 40,
              width: 40,
              child: FadeInImage(
                image: user.image != null ? NetworkImage(user.image) : AssetImage('assets/img/pizza2.png'),
                fit: BoxFit.contain,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ) ,
            SizedBox(width: 5,) ,
            Text(user.name)
          ],
        ) ,
        value: user.id,
      ));
    });
    return list;
  }


  Widget _textData(String title , String content){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          content ,
          maxLines: 2,
        ),
      )
    );
  }



  Widget _buttonNext(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 10 , bottom: 20),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 5) ,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 40,
                child: Text(
                  'SEGUIR PEDIDO',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ) ,
                ),
              ),
            ) ,
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 3),
                height: 30,
                child: Icon(
                  Icons.directions_bike,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _cardProduct(Product product){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProducto(product),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ) ,
              SizedBox(height: 4,),
              Text(
                'Cantidad: ${product.quantity}',
              ) ,
              SizedBox(height: 4,),
              Text(
                'Precio: \$ ${ product.quantity * product.price}',

              ) ,
            ],
          ),
        ],
      ),
    );
  }

  Widget _textTotalPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ) ,
          Text(
            '\$ ${ double.parse(_con.total.toStringAsFixed(2))  }',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          )
        ],
      ),
    );
  }


  Widget _imageProducto(Product product){
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]
      ),
      width: 55,
      height: 55,
      child :  FadeInImage(
        image: product.image1 != null ? NetworkImage(product.image1) : AssetImage('assets/img/pizza2.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  Function refresh(){
    setState(() {

    });
  }
}
