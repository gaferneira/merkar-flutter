import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merkar/app/core/extensions/numberFormat.dart';
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
    "Vinos", "Pasabocas", "Saludable","Aromáticas y espécias"
  ];
  List<FaIcon> iconsCategory=[
    FaIcon(FontAwesomeIcons.carrot), FaIcon(FontAwesomeIcons.appleAlt),
    FaIcon(FontAwesomeIcons.doorClosed), FaIcon(FontAwesomeIcons.cloudMeatball),
    FaIcon(FontAwesomeIcons.egg), FaIcon(FontAwesomeIcons.bookmark),
    FaIcon(FontAwesomeIcons.breadSlice), FaIcon(FontAwesomeIcons.toiletPaper),
    FaIcon(FontAwesomeIcons.soap), FaIcon(FontAwesomeIcons.cookie),
    FaIcon(FontAwesomeIcons.prescriptionBottleAlt), FaIcon(FontAwesomeIcons.glassMartiniAlt),
    FaIcon(FontAwesomeIcons.beer), FaIcon(FontAwesomeIcons.dog),
    FaIcon(FontAwesomeIcons.medkit), FaIcon(FontAwesomeIcons.houseDamage),
    FaIcon(FontAwesomeIcons.snowplow), FaIcon(FontAwesomeIcons.wineBottle),
    FaIcon(FontAwesomeIcons.candyCane), FaIcon(FontAwesomeIcons.seedling),
    FaIcon(FontAwesomeIcons.pepperHot),
  ];
  Map<String,FaIcon> categoriesIcons={
    "Verduras":FaIcon(FontAwesomeIcons.carrot),
    "Frutas":FaIcon(FontAwesomeIcons.appleAlt),
    "Despensa": FaIcon(FontAwesomeIcons.doorClosed),
    "Carnes": FaIcon(FontAwesomeIcons.cloudMeatball),
    "Lácteos y huevos":FaIcon(FontAwesomeIcons.egg),
    "Otros":FaIcon(FontAwesomeIcons.bookmark),
    "Panaderia":FaIcon(FontAwesomeIcons.breadSlice),
    "Aseo personal":FaIcon(FontAwesomeIcons.toiletPaper),
    "Aseo hogar":FaIcon(FontAwesomeIcons.soap),
    "Galletas y dulces":FaIcon(FontAwesomeIcons.cookie),
    "Bebidas":FaIcon(FontAwesomeIcons.prescriptionBottleAlt),
    "Licores":FaIcon(FontAwesomeIcons.glassMartiniAlt),
    "Cerveza":FaIcon(FontAwesomeIcons.beer),
    "Mascotas":FaIcon(FontAwesomeIcons.dog),
    "Droguería":FaIcon(FontAwesomeIcons.medkit),
    "Hogar":FaIcon(FontAwesomeIcons.houseDamage),
    "Congelados":FaIcon(FontAwesomeIcons.snowplow),
    "Vinos":FaIcon(FontAwesomeIcons.wineBottle),
    "Pasabocas":FaIcon(FontAwesomeIcons.candyCane),
    "Saludable":FaIcon(FontAwesomeIcons.seedling),
    "Aromáticas y espécias":FaIcon(FontAwesomeIcons.pepperHot),
  };
  List<String> defaultUnits=[
    "Unidad", "Libra","Kilogramo",
    "Paquete", "Atado", "Litro", "Ml",
    "Cubeta"
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
      }
          }
        );
  }
}
