// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/quote.dart';
//
// class ApiService {
//   static const String _url = 'https://api.quotable.io/random';
//
//   static Future<Quote?> fetchRandomQuote() async {
//     try {
//       final response = await http.get(Uri.parse(_url));
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return Quote(quote: data['content'], author: data['author']);
//       } else {
//         throw Exception('Failed to load quote');
//       }
//     } catch (e) {
//       print("API Error: $e");
//       return null;
//     }
//   }
// }
