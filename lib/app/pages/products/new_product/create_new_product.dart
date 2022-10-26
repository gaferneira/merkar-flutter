import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merkar/app/core/extensions/number_format.dart';
import '../../../core/resources/constants.dart';
import '../../../core/resources/strings.dart';
import '../../../widgets/primary_button.dart';
import '../../../../data/entities/product.dart';
import '../../../../injection_container.dart';
import 'create_new_product_view_model.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CreateNewProduct extends StatefulWidget {
  static const routeName = "/create_new_product";

  @override
  _CreateNewProductState createState() => _CreateNewProductState();
}

class _CreateNewProductState extends State<CreateNewProduct> {
  final keyNewProduct = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  CreateNewProductsViewModel viewModel =
      serviceLocator<CreateNewProductsViewModel>();
  final TextEditingController _typeAheadCategoryController = TextEditingController();
  final TextEditingController _typeAheadUnitController = TextEditingController();

  String? nameProduct;
  String? nameCategory;
  String? price;
  String? unit;
  Product? product;
  List<String> defaultCategorys=[
    "Verduras", "Frutas","Despensa","Carnes"
    ,"Lácteos y huevos","Otros","Panaderia","Aseo personal",
    "Aseo hogar", "Galletas y dulces", "Bebidas", "Licores",
    "Cerveza", "Mascotas", "Droguería", "Hogar", "Congelados",
    "Vinos", "Pasabocas", "Saludable","Aromáticas y espécias",
    "Electrónica y electrodomésticos","Papelería",
    "Pescados y mariscos","Ropa","Salud y belleza",
    "Libros y música",
  ];

  Map<String,FaIcon> categoriesIcons={
    "Verduras":FaIcon(FontAwesomeIcons.carrot,color: Colors.blueGrey,),
    "Frutas":FaIcon(FontAwesomeIcons.appleAlt,color: Colors.blueGrey),
    "Despensa": FaIcon(FontAwesomeIcons.doorClosed,color: Colors.blueGrey),
    "Carnes": FaIcon(FontAwesomeIcons.drumstickBite,color: Colors.blueGrey),
    "Lácteos y huevos":FaIcon(FontAwesomeIcons.egg,color: Colors.blueGrey),
    "Otros":FaIcon(FontAwesomeIcons.solidBookmark,color: Colors.blueGrey),
    "Panaderia":FaIcon(FontAwesomeIcons.breadSlice,color: Colors.blueGrey),
    "Aseo personal":FaIcon(FontAwesomeIcons.toiletPaper,color: Colors.blueGrey),
    "Aseo hogar":FaIcon(FontAwesomeIcons.soap,color: Colors.blueGrey),
    "Galletas y dulces":FaIcon(FontAwesomeIcons.cookie,color: Colors.blueGrey),
    "Bebidas":FaIcon(FontAwesomeIcons.tint,color: Colors.blueGrey),
    "Licores":FaIcon(FontAwesomeIcons.glassMartiniAlt,color: Colors.blueGrey),
    "Cerveza":FaIcon(FontAwesomeIcons.beer,color: Colors.blueGrey),
    "Mascotas":FaIcon(FontAwesomeIcons.dog,color: Colors.blueGrey),
    "Droguería":FaIcon(FontAwesomeIcons.medkit,color: Colors.blueGrey),
    "Hogar":FaIcon(FontAwesomeIcons.houseDamage,color: Colors.blueGrey),
    "Congelados":FaIcon(FontAwesomeIcons.solidSnowflake,color: Colors.blueGrey),
    "Vinos":FaIcon(FontAwesomeIcons.wineBottle,color: Colors.blueGrey),
    "Pasabocas":FaIcon(FontAwesomeIcons.candyCane,color: Colors.blueGrey),
    "Saludable":FaIcon(FontAwesomeIcons.seedling,color: Colors.blueGrey),
    "Aromáticas y espécias":FaIcon(FontAwesomeIcons.pepperHot,color: Colors.blueGrey),
    "Electrónica y electrodomésticos":FaIcon(FontAwesomeIcons.desktop,color: Colors.blueGrey),
    "Papelería":FaIcon(FontAwesomeIcons.paperclip,color: Colors.blueGrey),
    "Pescados y mariscos":FaIcon(FontAwesomeIcons.fish,color: Colors.blueGrey),
    "Ropa":FaIcon(FontAwesomeIcons.tshirt,color: Colors.blueGrey),
    "Salud y belleza":FaIcon(FontAwesomeIcons.airFreshener,color: Colors.blueGrey),
    "Libros y música":FaIcon(FontAwesomeIcons.bookOpen,color: Colors.blueGrey),
  };
  List<String> defaultUnits=[
    "Unidad", "Libra","Kilogramo",
    "Paquete", "Atado", "Litro", "ml",
    "Cubeta","Six pac","Botella","Garrafa"
  ];

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)!.settings.arguments as Product?;
    if(product != null){
      _typeAheadCategoryController.text=product!.category!;
      _typeAheadUnitController.text=numberFormat(product!.unit!.toString());
    }
    return SlideInDown(
      child: Scaffold(
        appBar: AppBar(
          title: (product == null)
              ? Text(Strings.title_new_product)
              : Text(Strings.editProductTittle + " " + product!.name!),
        ),
        body: SingleChildScrollView(child: _fromCreateProduct()),
      ),
    );
  }
  Widget _fromCreateProduct() {
    return Form(
      key: keyNewProduct,
      child: Padding(
        padding: const EdgeInsets.all(Constant.normalspacecontainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            TextFormField(
              initialValue: product?.name ?? "",
              autofocus: true,
              decoration: InputDecoration(labelText: Strings.label_name),
              onSaved: (value) {
                nameProduct = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return Strings.error_required_field;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadCategoryController,
                  decoration: InputDecoration(
                      labelText: Strings.category
                  )
              ),
              suggestionsCallback: (pattern) {
                return getCategorySuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                  trailing: categoriesIcons['$suggestion'],
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              hideOnEmpty: true,
              onSuggestionSelected: (suggestion) {
                this._typeAheadCategoryController.text = suggestion.toString();
              },
              onSaved: (value) {
                nameCategory = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },

            ),
            SizedBox(height: Constant.normalspace),
            TextFormField(
              initialValue: product?.price ?? "",
              decoration: InputDecoration(labelText: Strings.price),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                price = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: Constant.normalspace),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadUnitController,
                  decoration: InputDecoration(
                      labelText: Strings.unit
                  )
              ),
              suggestionsCallback: (pattern) {
                return getUnitSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion.toString()),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadUnitController.text = suggestion.toString();
              },
              hideOnEmpty: true,
              onSaved: (value) {
                unit = value;
              },
              validator: (value) {
                if (value!.isNotEmpty) {
                  return null;
                }
                return Strings.error_required_field;
              },
            ),
            SizedBox(height: Constant.normalspace),
            Center(
              child: _buildSaveButton(),
            ),
          ],
        ),
      ),
    );
  }
  List<String>getCategorySuggestions(String query){
    List<String> suggestions=[];
    suggestions = defaultCategorys
        .where((category) =>
        category.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return suggestions;
  }

  List<String>getUnitSuggestions(String query){
    List<String> suggestions=[];

    suggestions = defaultUnits
        .where((category) =>
        category.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return suggestions;
  }

  Widget _buildSaveButton(){
    if (viewModel.error != null) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: Text(viewModel.error!),
          duration: const Duration(seconds: 1)));
      viewModel.error = null;
    }
    return  PrimaryButton(
        title: Strings.label_save,
        onPressed: () {
      if (keyNewProduct.currentState!.validate() == true) {
        keyNewProduct.currentState!.save();
        Product newProduct = new Product(
            category: nameCategory,
            name: nameProduct,
            price: price.toString(),
            unit: unit);
        if (product != null) {
          newProduct.id = product!.id;
          newProduct.path = product!.path;
        }
        viewModel.saveProduct(newProduct, context);
        Navigator.pop(context);
      }
          }
        );
  }
}
