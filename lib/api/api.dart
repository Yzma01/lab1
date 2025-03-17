import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<List<dynamic>> requestUsers() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body) as List<dynamic>;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return []; // Retorna una lista vacía en caso de error
  }
}
