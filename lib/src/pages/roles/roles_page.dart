import 'package:delivery_project/src/models/rol.dart';
import 'package:delivery_project/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  RolesController _con = new RolesController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Le pasamos nuestro metodo para refrescar tambien
      _con.init(context , refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona un rol'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.10),
        child: ListView(
          children: _con.user != null ? _con.user.roles.map((Rol rol) {
            return _cardRol(rol);
          }).toList() : []
        ),
      )
    );
  }

  Widget _cardRol(Rol rol){
    return GestureDetector(
      onTap: (){
        _con.goToPage(rol.route);
      },
      child: Column(
        children: [
          Container(
            height: 100,
            child: FadeInImage(
              image: NetworkImage(rol.image) ,
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.jpg') ,
            ),
          ),
          SizedBox(height: 20,),
          Text(
            rol.name,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }

  void refresh(){
    // Con este refrescamos la pantalla
    setState(() {});
  }
}
