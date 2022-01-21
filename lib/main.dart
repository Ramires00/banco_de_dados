import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

/* No pubspec.yaml colocar a dependencia do banco de dados
    que será utilizado ex: sqflite: ^1.1.0
 */

_recuperarBancoDados() async{ //async, pois pode demorar até receber os dados

  //Criando caminho do banco de dados
  final caminhoBancoDados = await getDatabasesPath(); //getDatabasesPath recupera o caminho.
  final localBancoDados = join(caminhoBancoDados, "banco.bd"); //criando arquivo do banco de dados
      //caso já tenha um banco de dados criado ele ignora esse código de cima ^^^

  var bd = await openDatabase(
    localBancoDados,
    version: 1,
    onCreate: (db, dbVersaoRecence){
      String sql = "CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)";
      db.execute(sql);
    } // o db serve para fazer alterações no banco de dados.
  ); //ele vai criar o banco de dados.
  return bd;
  //print ("aberto:" + bd.isOpen.toString() ); // caso tenha sido possivel criar o banco de dados ele retorna um booleano.
}

_salvarDados() async {
  
  Database bd = await _recuperarBancoDados(); //Banco de dados.

  Map<String, dynamic> dadosUsuario = {
    "nome" : "teste",
    "idade" : 10,
  };
  int id = await bd.insert("usuarios", dadosUsuario);// o segundo parâmetro pega o valor de um map;
  print("Salvo:  $id" );
} //bd insert para inserir dados no BD usamos um map para passar os dados como mostra no código

_listarUsuarios() async{

  Database bd = await _recuperarBancoDados();
  //listando dados
  String filtro = "an";
  String sql = "SELECT * FROM usuarios WHERE nome LIKE '%" + filtro + "%' "; // aqui utilizamos um filtro, e como usa-lo;
  // Para pesquisas mais especificas utilizar o where e passar uma condição ex: WHERE idade >= 58; ainda existem o AND e o OR como condição,
  List usuarios = await bd.rawQuery(sql); // escrever a query, o RawQuery retorna uma lista
  print("usuarios" + usuarios.toString()); // outro operador: LIKE(como), para fazer uma busca tem que por a % no final '%mires%' ou entre ele;
  // temos támbem ASCENDENTE(ASC) E DESCENDENTE(DESC), ORDER BY(Ordenar por), tabela, ORDER BY UPPER(nome) ASC;
  //temos tambem o BETWEEN(entre) IN(em),ex idade BETWEEN 30 AND 50, aqui tanto faz usar o between ou o in;
  // podemos usar o LIMIT que ele limita a quantidade de dados recuperados;
  for (var usuario in usuarios){
    print(
      "item id: " + usuario['id'].toString() +
        "nome: " + usuario['nome'] +
        " idade: " + usuario['idade'].toString()
    );
  } // percorrendo a lista de usuarios
}// listando todos os usuarios;

_recuperarUsuarioPeloId(int id) async {
  Database bd = await _recuperarBancoDados(); //banco de dados

  List usuarios = await bd.query(
    "usuarios",
    columns: ["id", "nome", "idade"],
    where: "id = ?", // nosso ID é uma chave primaria
    whereArgs: [id]
  );

  for (var usuario in usuarios ){
    print(""
        "item id: " + usuario['id'].toString() +
        "nome: " + usuario['nome'] +
        "idade: " + usuario['idade'].toString()
    );
  }
}

 _excluirUsuario(int id) async{

  Database bd = await _recuperarBancoDados();
    // retorno será a quantidade de registro que estão sendo excluidos
   int retorno = await bd.delete(
    "usuarios",
    where: "id = ?", //caso não tenha a clausura where ele apaga todos os registros da tabela usuarios.
    whereArgs: [id]
  );
   print("id qtnd removida:  $retorno");

}

_atualizarUsuario(int id) async{
  Database bd = await _recuperarBancoDados();

  Map<String, dynamic> dadosUsuario = {
    "nome" : "Ramires Rodrigues alterado",
    "idade " : 3919,
  };
 int retorno = await bd.update( // passa a tabela e um Map com a atualização dos dados como pode ver
    "usuarios",
    dadosUsuario
  );
 print("item qtde atualizada: $retorno");
}


class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {

    //_salvarDados();
    //_listarUsuarios();
    //_recuperarUsuarioPeloId(1);
    //_excluirUsuario(1);
    return Container();
  }

}
