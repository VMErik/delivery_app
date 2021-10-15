
import 'package:delivery_project/src/models/product.dart';
import 'package:delivery_project/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductsDetailPage extends StatefulWidget {
  Product product;

  ClientProductsDetailPage({Key key , @required this.product}) : super(key: key);

  @override
  _ClientProductsDetailPageState createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {

  ClientProductsDetailController _con = new ClientProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh , widget.product );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          _imageSlideShow() ,
          _textName() ,
          _textDescription() ,
          Spacer(),
          _addRemoveItem() ,
          _standardDelivery(),
          _buttonShopingBag()
        ],
      ),
    );
  }

  Widget _buttonShopingBag(){
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30 , bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToBag,
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
                  'AGREGAR A LA BOLSA',
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
                margin: EdgeInsets.only(left: 50, top: 7),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _addRemoveItem(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [


          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline ,
                color: Colors.redAccent,
                size: 30,)
          ) ,
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),
          ),
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                Icons.add_circle_outline ,
                color: Colors.green,
                size: 30,)
          ) ,
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '\$ ${ double.parse(_con.productoPrice.toStringAsFixed(2)) ??  0}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ) , 
        ],
      ),
    );
  }
  
  Widget _standardDelivery(){
    return Container(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30 , vertical: 10),
        child: Row(
          children: [
            Image.asset(
                'assets/img/delivery.png',
              height: 18,
            ) ,
            SizedBox(width: 7,),
            Text(
              'En existencia',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textName(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _con.product?.name ?? '' ,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 7),
      child: Text(
        _con.product?.description ?? '' ,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          color: Colors.grey

        ),
      ),
    );
  }


  Widget _imageSlideShow(){
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image: _con.product?.image1 != null ? NetworkImage(_con.product.image1) : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product?.image2 != null ? NetworkImage(_con.product.image2) : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.product?.image3 != null ? NetworkImage(_con.product.image3) : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ],
          onPageChanged: (value) {
            print('Page changed: $value');
          },
          autoPlayInterval: 15000,
          isLoop: true,
        ),
        Positioned(
          left: 10,
          top: 5,
          child: IconButton(
            onPressed: _con.close,
            icon : Icon(Icons.arrow_back_ios),
            color: MyColors.primaryColor,
          ),
        )
      ],
    );
  }

  Function refresh(){
    setState(() {

    });
  }

}
