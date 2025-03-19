import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../helpers/contact_helper.dart";

class ContactPage extends StatefulWidget {
  final Contact? contact;

  const ContactPage({super.key, this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final _nameFocus = FocusNode();

  late Contact _editedContact;
  bool _userEdited = false;
  @override
  void initState() {
    super.initState();

    _editedContact = widget.contact != null
        ? Contact.fromMap(widget.contact!.toMap())
        : Contact();

    _nameController.text = _editedContact.name ?? "";
    _emailController.text = _editedContact.email ?? "";
    _phoneController.text = _editedContact.phone ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false, // Impede a navegação para a página anterior
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _requestPop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato", style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name!.isNotEmpty){
              Navigator.pop(context, _editedContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.save, color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _editedContact.img != null && _editedContact.img!.isNotEmpty
                            ? FileImage(File(_editedContact.img!)) as ImageProvider
                            : AssetImage("images/person.png") as ImageProvider,
                      )
                  ),
                ),
                onTap: (){
                  _showImageSourceDialog(context);
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-mail"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Escolha a origem da imagem'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Câmera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Galeria'),
            ),
          ],
        );
      },
    );

    if (source != null) {
      final XFile? file = await _picker.pickImage(source: source);
      if (file == null) return;
      setState(() {
        _editedContact.img = file.path;
        _userEdited = true;
      });
    }
  }

  Future<bool> _requestPop(BuildContext context) async {
    if (_userEdited) {
      bool? result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar Alterações?'),
            content: const Text('Se sair, as alterações serão perdidas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.pop(context, false);
                },
                child: const Text('Sim'),
              ),
            ],
          );
        },
      );
      return result ?? false;
    } else {
      Navigator.pop(context, true);
      return true;
    }
  }
}
