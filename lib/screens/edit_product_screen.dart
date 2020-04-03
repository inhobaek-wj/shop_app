import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    // this is important and you should do it, otherwise memory leak will be caused.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product')
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          child: ListView(
            children: <Widget>[

              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,
              ),

            ],
          ),
        ),
      ),

    );
  }
}
