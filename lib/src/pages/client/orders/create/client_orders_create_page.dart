import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({Key key}) : super(key: key);

  @override
  _ClientOrdersCreatePageState createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {

  ClientOrdersCreateController _con = new ClientOrdersCreateController();

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
      appBar: AppBar(
        title: Text(
          'Resumen de mi orden'
        ),
      ),
      body: _con.selectedProducts.length > 0
            ? ListView(
          children: _con.selectedProducts.map((Product product){
            return _cardProduct(product);
          }).toList(),
      )
      : NoDataWidget(text: 'Tu bolsa de compra esta vacia'),
      // Para mandarlo al final de la pantalla
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.235,
        child : Column(
          children: [
            Divider(
              color: Colors.grey[400],
              endIndent: 30, // Maregn en la parte izquierda
              indent: 30, // Margen en la parte derecha
            ),
            _textTotalPrice(),
            _buttonNext(),
          ],
        )
      ),
    );
  }


  Widget _buttonNext(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30 , bottom: 30),
      child: ElevatedButton(
        onPressed: _con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5) ,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  'REALIZAR COMPRA',
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
                margin: EdgeInsets.only(left: 60, top: 10),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
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
              SizedBox(height: 10,),
              _addOrRemoveItem(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product), 
              _iconDelete(product)
            ],
          )
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


  Widget _iconDelete(Product product){
    return IconButton(onPressed: (){
      _con.deleteItem(product);
    }, icon: Icon(Icons.delete , color: MyColors.primaryColor,));
  }

  Widget _textPrice(Product product){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '\$ ${  double.parse(( product.price * product.quantity).toStringAsFixed(2))   }',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey
        ),
      ),
    );
  }


  Widget _imageProducto(Product product){
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]
      ),
      width: 90,
      height: 90,
      child :  FadeInImage(
        image: product.image1 != null ? NetworkImage(product.image1) : AssetImage('assets/img/pizza2.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  Widget _addOrRemoveItem(Product product){
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            _con.removeItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Text(
              '-',
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey[200]
            ),
          ),
        ),
        Container(
          color:  Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
              '${product.quantity ?? 0}'
          ),
        ) ,
        GestureDetector(
          onTap: (){
            _con.addItem(product);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Text(
              '+',
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.grey[200]
            ),
          ),
        ),
      ],
    );
  }


  Function refresh(){
    setState(() {

    });
  }
}
