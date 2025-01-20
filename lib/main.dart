import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Flutter',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: PostListScreen(),
    );
  }
}

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('http://localhost:8080/posts'));
    if (response.statusCode == 200) {
      setState(() {
        posts = jsonDecode(response.body);
      });
    }
  }

  void navigateToAddPost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPostScreen()),
    );
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Server', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post['texto']),
            leading: post['imagem'] != null
                ? Image.memory(
                    base64Decode(post['imagem']),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : SizedBox.shrink(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPost,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _textController = TextEditingController();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _imageBytes = File(pickedFile.path).readAsBytesSync();
        });
      }
    }
  }

  Future<void> submitPost() async {
    if (_textController.text.isEmpty || _imageBytes == null) return;

    final base64Image = base64Encode(_imageBytes!);

    final response = await http.post(
      Uri.parse('http://localhost:8080/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'texto': _textController.text,
        'imagem': base64Image,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Post', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Texto'),
            ),
            SizedBox(height: 16),
            _imageBytes == null
                ? Text('Nenhuma imagem selecionada')
                : Image.memory(
                    _imageBytes!,
                    width: 150, // Largura fixa para o preview
                    height: 150, // Altura fixa para o preview
                    fit: BoxFit.cover, // Ajuste da imagem
                  ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Selecionar Imagem'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitPost,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
