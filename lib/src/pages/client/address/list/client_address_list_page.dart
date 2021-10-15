import 'package:delivery_project/src/models/address.dart';
import 'package:delivery_project/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:delivery_project/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key key}) : super(key: key);

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {

  ClientAddressListController _con = new ClientAddressListController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _con.init(context, refresh);
    });

  }

  void refresh(){
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Direcciones'),
        actions: [
          _iconAdd(),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: _textSelectAddress(),
          ),
          Container(
            margin: EdgeInsets.only(top: 50),
              child: _listAddress()
          )
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _listAddress(){
    return  FutureBuilder(
      future: _con.getAddress(),
      builder: (context, AsyncSnapshot<List<Address>> snapshot){
        if(snapshot.hasData){
          if (snapshot.data.length > 0){
            return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (_, index ){
                  return _radioSelectorAddress( snapshot.data[index]  , index );
                });
          }else{
            return _noAddress();
          }
        }else{
          return _noAddress();
        }
      },
    );
  }

  Widget _noAddress(){
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20),
            child: NoDataWidget(text: 'Agrega una nueva dirección',)
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _radioSelectorAddress(Address address , int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _con.radioValue,
                onChanged: _con.handleRadioValueChange,
              ) ,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      address?.address ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13
                    ),
                  ),
                  Text(
                    address?.neighborhood ?? '',
                    style: TextStyle(
                        fontSize: 12
                    ),
                  )
                ],
              )
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );

  }


  Widget  _buttonNewAddress(){
    return Container(
      height: 35,
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: Text('Nueva Direccion'),
        style: ElevatedButton.styleFrom(
            primary: Colors.blueAccent
        ),
      ),
    );
  }


  Widget  _buttonAccept(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      child: ElevatedButton(
        onPressed: _con.createOrder,
        child: Text('ACEPTAR'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(30)
          ),
          primary: MyColors.primaryColor
        ),
      ),
    );
  }

  Widget _textSelectAddress(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
          'Elige donde recibir tus compras',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }
  
  Widget  _iconAdd(){
    return IconButton(
        onPressed: _con.goToNewAddress,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        )
    );
  }


}
