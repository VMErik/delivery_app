import 'package:delivery_project/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:delivery_project/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'client_payments_installments_controller.dart';

class ClientPaymentsInstsallmentsPage extends StatefulWidget {
  const ClientPaymentsInstsallmentsPage({Key key}) : super(key: key);

  @override
  _ClientPaymentsInstsallmentsPageState createState() => _ClientPaymentsInstsallmentsPageState();
}

class _ClientPaymentsInstsallmentsPageState extends State<ClientPaymentsInstsallmentsPage> {

  ClientPaymenstInstallmentController _con = new ClientPaymenstInstallmentController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Function refresh(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuotas'),
      )
    );
  }

  Widget _buttonNext(){
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30 , bottom: 20),
      child: ElevatedButton(
        onPressed :  _con.createCardToken,
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
                  'CONTINUAR',
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
                margin: EdgeInsets.only(left: 50, top: 8),
                height: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
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
}
