import 'package:ShopApp/providers/product_overview_model.dart';
import 'package:ShopApp/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final String id;
  EditScreen(this.id);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var _isLoading = false; // never do this in the build, it won't work
  Widget build(BuildContext context) {
    final prodlist = Provider.of<ProductsProvider>(context);
    final _priceFocus = FocusNode();
    final _descriptionFocus = FocusNode();
    final _imageUrlController =
        TextEditingController(); // we create this controller because we preview this image in the
    // container.
    final _imageFocus = FocusNode();

    final _formKey = GlobalKey<
        FormState>(); // We rarely use Global Key, only when we need to interact with widget from
    // inside of the code.
    var _createsProduct = (widget.id == null)
        ? ProdOverview(
            description: '',
            id: '',
            imageUrl: '',
            name: '',
            price: 0.0,
          )
        : prodlist.findById(widget
            .id); // We created an empty instance and then change the value below as the user enters them.
    _imageUrlController.text = _createsProduct.imageUrl;
    void imageListener() {
      if (!_imageFocus.hasFocus) {
        setState(
            () {}); // And when the feild has no focus then we rebuild the ui to load the preview image.
      }
    }

    void initState() {
      _imageFocus.addListener(
          imageListener); // this is a listener when the focus is moved from the image url feild the image
      // automatically previews in the container next to it.
      super.initState();
    }

    @override
    void dispose() {
      // We need to dispose off with the controllers and focus nodes when done with them, because they take up space in memory
      // and can cause memory leaks.
      _imageFocus.removeListener(imageListener);
      _priceFocus.dispose();
      _imageUrlController.dispose();
      _descriptionFocus.dispose();
      _imageFocus.dispose();
      super.dispose();
    }

    Future<void> _savedata() async {
      // try, catch and async and await just makes the code more readable than then, catch error
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        _formKey.currentState.save();
      }

      if (widget.id == null) {
        try {
          await prodlist.addProduct(_createsProduct);
        } catch (err) {
          await showDialog(
            // we use await where we want to wait till that function is over and when that function returns a future.
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error:'),
              content: Text('Oops! Something went wrong'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
          );
        } finally {
          // finally executes the function which dont matter on the value of try and catch, it always executes no matters what
          // happens.
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
      } else {
        await prodlist.updateProd(_createsProduct, widget.id);
        print(widget.id);
        setState(() {
          _isLoading = false;
        });
        print(_isLoading);
        Navigator.of(context).pop();
      }
    }

    // alternative to the _save data form up there that uses try and catch
    /* void _savedata() {
      if (_formKey.currentState.validate()) {
        // this returns true if all the validators in form returns true and false if even
        // one of them returns a string that is false.
        setState(() {
          _isLoading =
              true; // we set that to true so we know that we are loading.
        });
        print(_isLoading);
        _formKey.currentState.save();
        if (widget.id == null) {
          // we are now going to use the future that we returned from addProduct function
          prodlist.addProduct(_createsProduct).catchError((err) {
            return showDialog(
              // because showDialog also returns a future and we want to close it only when the user clicks on 'OK'.
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Error:'),
                content: Text('Oops! Something went wrong'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        _isLoading =
                            false; // here we set it to false because the add operation is finished and now the loading stops.
                      });
                      print(_isLoading);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }).then((value) {
            setState(() {
              _isLoading = false;
              Navigator.of(context).pop();
            });
          });
        } else {
          prodlist.updateProd(_createsProduct, widget.id);
          setState(() {
            _isLoading = false;
          });
          print(_isLoading);
          Navigator.of(context).pop();
        }
      }
    }
 */
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          FlatButton(
            onPressed: _savedata,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'JosefinSans',
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'Edit Products',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'JosefinSans',
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: (_isLoading)
          ? Center(
              child:
                  CircularProgressIndicator(), // now while the _isLoading is true we want to show circular progress indicator.
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                // We are using forms because it provides some useful built-in functions for saving and validation, that
                // are better than creating input feilds and adding complex validation ourselves,
                key:
                    _formKey, // now we assign the key to the form to establish the connection.
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _createsProduct.name,
                        textInputAction: TextInputAction
                            .next, // this ensures that when we press the corner button in soft keyboard
                        // we go the next feild instead of submitting the form.
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                          // this function here navigates to the next feild with that focus node.
                        },
                        onSaved: (value) {
                          // this is where the value changes, only that value changes which is entered by the user,
                          // everything else remains the same.
                          _createsProduct = ProdOverview(
                            name: value,
                            id: _createsProduct.id,
                            description: _createsProduct.description,
                            imageUrl: _createsProduct.imageUrl,
                            price: _createsProduct.price,
                            isFav: _createsProduct.isFav,
                          );
                        },
                        validator: (value) {
                          // this is a validator and put all your validation logic here.
                          if (!value.isEmpty) {
                            return null;
                          }
                          return 'Please fill the feild correctly';
                        },
                      ),
                      TextFormField(
                        initialValue: _createsProduct.price.toString(),
                        textInputAction: TextInputAction
                            .next, // this ensures that when we press the corner button in sodt keyboard
                        // we go the next feild instead of submitting the form.
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        keyboardType:
                            TextInputType.number, // a numeric keyboard pops up.
                        focusNode:
                            _priceFocus, // now this feild has that focus node attached so that the above feild knows where
                        // to focus when corner button is pressed on soft keyboard.
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        onSaved: (value) {
                          _createsProduct = ProdOverview(
                            name: _createsProduct.name,
                            id: _createsProduct.id,
                            description: _createsProduct.description,
                            imageUrl: _createsProduct.imageUrl,
                            price: double.parse(value),
                            isFav: _createsProduct.isFav,
                          );
                        },
                        validator: (value) {
                          if (!value.isEmpty && double.parse(value) > 0.0) {
                            return null;
                          }
                          return 'Please fill the feild correctly';
                        },
                      ),
                      TextFormField(
                        initialValue: _createsProduct.description,
                        focusNode: _descriptionFocus,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3, // because description are ussually big
                        keyboardType: TextInputType
                            .multiline, // a keyboard suited for multi line text
                        onSaved: (value) {
                          _createsProduct = ProdOverview(
                            name: _createsProduct.name,
                            id: _createsProduct.id,
                            description: value,
                            imageUrl: _createsProduct.imageUrl,
                            price: _createsProduct.price,
                            isFav: _createsProduct.isFav,
                          );
                        },
                        validator: (value) {
                          if (!value.isEmpty) {
                            return null;
                          }
                          return 'Please fill the feild correctly';
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // we cannot give a initial value because we are using a controller. So we give the controller the
                              //initial value.
                              focusNode: _imageFocus,
                              controller: _imageUrlController,
                              decoration: InputDecoration(
                                labelText: 'Image Url',
                              ),
                              keyboardType: TextInputType.url,
                              onSaved: (value) {
                                _createsProduct = ProdOverview(
                                  name: _createsProduct.name,
                                  id: _createsProduct.id,
                                  description: _createsProduct.description,
                                  imageUrl: value,
                                  price: _createsProduct.price,
                                  isFav: _createsProduct.isFav,
                                );
                              },
                              validator: (value) {
                                if (!value.isEmpty) {
                                  return null;
                                }
                                return 'Please fill the feild correctly';
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
    );
  }
}

class ProductProvider {}
