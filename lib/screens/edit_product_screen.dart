import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    imageUrl: '',
    description: ''
  );
  bool _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    // this is important and you should do it, otherwise memory leak will be caused.
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      return;
    }
    _isInit = false;

    final String productId = ModalRoute.of(context).settings.arguments as String;
    if (productId != null) {
      _editedProduct =
      Provider.of<Products>(context,listen: false).findById(productId);

      _imageUrlController.text = _editedProduct.imageUrl;
    }

    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final bool _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }

    _form.currentState.save();

    if (_editedProduct.id != null) {
      Provider.of<Products>(context,listen: false)
      .updateProduct(_editedProduct.id,_editedProduct);

    } else {
      Provider.of<Products>(context,listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _form,

          child: ListView(
            children: <Widget>[

              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },

                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please type';
                  }
                  return null;
                },

                initialValue: _editedProduct.title,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (String value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },

                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please type';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please type valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please type valid number';
                  }
                  return null;
                },

                initialValue: _editedProduct.price == 0 ? ''
                : _editedProduct.price.toString(),

              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _descriptionFocusNode,

                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: value,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please type';
                  }
                  return null;
                },

                initialValue: _editedProduct.description,

              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),

                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      )
                    ),

                    child: _imageUrlController.text.isEmpty ? Text('Enter a URL')
                    : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },

                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: value,
                          description: _editedProduct.description,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },

                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please type';
                        }
                        if (!value.startsWith('http')
                          && !value.startsWith('http')
                          && !value.endsWith('.jpg')
                          && !value.endsWith('.png')) {
                          return 'Please type vaid URL';
                        }
                        return null;
                      },

                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),

    );
  }
}
