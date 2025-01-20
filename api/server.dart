import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

Response _handleOptions(Request request) {
  return Response.ok(
    '',
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
    },
  );
}

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return _handleOptions(request);
      }

      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type',
      });
    };
  };
}

void main() async {
  final posts = <Map<String, dynamic>>[];

  final router = Router();

  // Rota GET /posts
  router.get('/posts', (Request request) {
    return Response.ok(
      jsonEncode(posts),
      headers: {'Content-Type': 'application/json'},
    );
  });



  // Rota POST /posts
  router.post('/posts', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);

    if (data['texto'] == null || data['imagem'] == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Texto e imagem são obrigatórios'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final id = posts.length + 1;
    final newPost = {
      'id': id,
      'texto': data['texto'],
      'imagem': data['imagem'], // Base64 ou URL
    };

    posts.add(newPost);
    return Response(
      201,
      body: jsonEncode(newPost),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(router.call);

  const port = 8080;
  await io.serve(handler, 'localhost', port);
  print('API rodando em http://localhost:$port');
}
