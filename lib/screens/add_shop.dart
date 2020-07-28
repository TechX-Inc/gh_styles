import 'package:gh_styles/models/shops_model.dart';
import 'package:gh_styles/providers/add_shop_provider.dart';
import 'package:gh_styles/widgets/add_shop_form.dart';
import 'package:flutter/material.dart';
import 'package:gh_styles/widgets/business_logo_picker.dart';
import 'package:provider/provider.dart';

class AddShop extends StatefulWidget {
  bool editMode;
  final ShopsModel shopsModel;

  AddShop({this.editMode = false, this.shopsModel});
  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("==================== ${widget.editMode} =================");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color.fromRGBO(109, 0, 39, 1),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                      child: ChangeNotifierProvider(
                          create: (context) => AddShopProvider(),
                          child: FormWrapper(
                            shopsModel: widget.shopsModel,
                          ))),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class FormWrapper extends StatelessWidget {
  final ShopsModel shopsModel;
  FormWrapper({this.shopsModel});
  AddShopProvider cancelUpload;
  @override
  Widget build(BuildContext context) {
    cancelUpload = Provider.of<AddShopProvider>(context, listen: false);
    return Column(
      children: <Widget>[
        FractionallySizedBox(
          widthFactor: 1,
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              shopsModel != null
                  ? ShopLogo(logoUrl: shopsModel?.shopLogoPath)
                  : ShopLogo(),
              SizedBox(
                height: 10,
              ),
              Consumer<AddShopProvider>(
                builder: (context, data, _) {
                  if (shopsModel != null) {
                    return FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Icon(Icons.cancel, color: Colors.white),
                      onPressed: () {
                        data.removeLogo();
                      },
                    );
                  } else {
                    return data.image == null
                        ? Text(
                            "Add Logo",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )
                        : FlatButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: Icon(Icons.cancel, color: Colors.white),
                            onPressed: () {
                              data.removePhoto = null;
                            },
                          );
                  }
                },
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: ShopForms(shopsModel: shopsModel),
          ),
        ),
      ],
    );
  }
}
