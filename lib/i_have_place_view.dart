import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:yerlazim/model/source.dart';
import 'package:yerlazim/place_service.dart';
import 'package:yerlazim/util/Uuid.dart';

import 'address_search.dart';
import 'db.dart';

class IHavePlaceForm extends StatefulWidget {
  const IHavePlaceForm({Key? key}) : super(key: key);

  @override
  State<IHavePlaceForm> createState() {
    return _IHavePlaceFormState();
  }
}

class _IHavePlaceFormState extends State<IHavePlaceForm> {
  void _onChanged(dynamic val) => debugPrint(val.toString());
  final _controller = TextEditingController();
  final _noteController = TextEditingController();
  String? _city = "";
  String _address = "";

  double _latitude = 0.0;
  double _longitude = 0.0;

  final _formKey = GlobalKey<FormBuilderState>();
  bool _nameHasError = false;
  bool _surnameHasError = false;
  bool _phoneHasError = false;
  bool _phone2HasError = false;
  bool _cityHasError = false;
  bool _addressHasError = false;

  var cityOptions = ['Adana', 'Adıyaman', 'Diyarbakır', 'Gaziantep', 'Hatay',
    'Kahramanmaraş', 'Kilis', 'Malatya', 'Osmaniye', 'Şanlıurfa',
    'Afyon',
    'Ağrı',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin	',
    'Aydın',
    'Balıkesir',
    'Bartın',
    'Batman',
    'Bayburt',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Düzce',
    'Edirne',
    'Elâzığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Giresun',
    'Gümüşhane',
    'Hakkâri',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Şırnak',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Konaklamaya Uygun Yerim Var"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            skipDisabled: true,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'Ad',
                    labelStyle: const TextStyle(fontSize: 20),
                    suffixIcon: _nameHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _nameHasError = !(_formKey.currentState?.fields['name']
                          ?.validate() ??
                          false);
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                FormBuilderTextField(
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'surname',
                  decoration: InputDecoration(
                    labelText: 'Soyad',
                    labelStyle: const TextStyle(fontSize: 20),
                    suffixIcon: _surnameHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _surnameHasError = !(_formKey.currentState?.fields['surname']
                          ?.validate() ??
                          false);
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                FormBuilderTextField(
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'phone',
                  decoration: InputDecoration(
                    labelText: 'Telefon Numarası',
                    labelStyle: const TextStyle(fontSize: 20),
                    suffixIcon: _phoneHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _phoneHasError = !(_formKey.currentState?.fields['phone']
                          ?.validate() ??
                          false);
                    });
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                FormBuilderTextField(
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'phone2',
                  decoration: InputDecoration(
                    labelText: 'Yedek Telefon Numarası',
                    labelStyle: const TextStyle(fontSize: 20),
                    suffixIcon: _phone2HasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _phone2HasError = !(_formKey.currentState?.fields['phone2']
                          ?.validate() ??
                          false);
                    });
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),

                FormBuilderDropdown<String>(
                  // autovalidate: true,
                  name: 'city',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'İl',
                    labelStyle: TextStyle(fontSize: 20, color: Colors.black),
                    suffix: _cityHasError
                        ? const Icon(Icons.error)
                        : const Icon(Icons.check),
                    hintText: 'İl Seçimi Yapın',
                  ),
                  // initialValue: 'Male',
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required()]),
                  items: cityOptions
                      .map((city) => DropdownMenuItem(
                    alignment: AlignmentDirectional.centerStart,
                    value: city,
                    child: Text(city),
                  ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _city = val;
                      _cityHasError = !(_formKey
                          .currentState?.fields['city']
                          ?.validate() ??
                          false);
                    });
                  },
                  valueTransformer: (val) => _city = val?.toString(),
                ),

                FormBuilderTextField(
                  minLines: 3,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'address',
                  decoration: InputDecoration(
                    labelText: 'Adres',
                    suffixIcon: _addressHasError
                        ? const Icon(Icons.error, color: Colors.red)
                        : const Icon(Icons.check, color: Colors.green),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _addressHasError = _controller.text.isEmpty;
                    });
                  },
                  controller: _controller,
                  readOnly: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  onTap: () async {
                        final sessionToken = Uuid().generateV4();
                        await PlaceApiProvider(sessionToken, context).openAddressSearch(
                                _city ?? "",
                                (address, lat, lng) =>
                        {
                          _controller.text = address ?? "",
                          _latitude = lat,
                          _longitude = lng
                        });
                  },
                ),

                FormBuilderTextField(
                  minLines: 3,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 20),
                  autovalidateMode: AutovalidateMode.always,
                  name: 'note',
                  decoration: const InputDecoration(
                    labelText: 'Eklemek istediğiniz bir not var mı?',
                  ),
                  onChanged: (val) {
                    setState(() {
                      _noteController.text = val ?? "";
                    });
                  },
                  controller: _noteController,
                ),

                const SizedBox(height: 30,),

                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                              var value = _formKey.currentState?.value;
                              if (value == null) {
                                debugPrint(_formKey.currentState?.value.toString());
                                debugPrint('validation failed');
                              }
                              debugPrint(_formKey.currentState?.value.toString());
                              var source = Source(
                                id: Uuid().generateV4(),
                                name: value!["name"],
                                surname: value["surname"],
                                phone: value["phone"],
                                phone2: value["phone2"] ?? "",
                                address: value["address"],
                                  city: _city ?? "",
                                  latitude: _latitude,
                                  longitude: _longitude,
                                note: value["note"]
                              );
                              Db.instance.createSource(source);

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Kayıt oluşturuldu. \n"
                                    "Yakınınızda ihtiyaç olduğu anda bildirim alacaksınız.")),
                              );
                            } else {
                              debugPrint(_formKey.currentState?.value.toString());
                              debugPrint('validation failed');
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              'Kayıt Oluştur',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //
                // TextField(
                //   controller: _controller,
                //   readOnly: true,
                //   onTap: () async {
                //     // generate a new token here
                //     final sessionToken = Uuid().generateV4();
                //     final Suggestion? result = await showSearch(
                //       context: context,
                //       delegate: AddressSearch(sessionToken),
                //     );
                //     // This will change the text displayed in the TextField
                //     if (result != null) {
                //       final placeDetails = await PlaceApiProvider(sessionToken)
                //           .getPlaceDetailFromId(result.placeId);
                //       setState(() {
                //         _controller.text = result.description;
                //         _streetNumber = placeDetails.streetNumber ?? "";
                //         _street = placeDetails.street ?? "";
                //         _city = placeDetails.city ?? "";
                //         _zipCode = placeDetails.zipCode ?? "";
                //       });
                //     }
                //   },
                //   decoration: InputDecoration(
                //     icon: Container(
                //       width: 10,
                //       height: 10,
                //       child: const Icon(
                //         Icons.home,
                //         color: Colors.black,
                //       ),
                //     ),
                //     hintText: "Konaklama Adresi",
                //     border: InputBorder.none,
                //     contentPadding: const EdgeInsets.only(left: 8.0, top: 16.0),
                //   ),
                // ),
                // const SizedBox(height: 20.0),
                // Text('Cadde no: $_streetNumber'),
                // Text('Cadde: $_street'),
                // Text('Şehir: $_city'),
                // Text('Posta Kodu: $_zipCode'),
      ]
        ),
          ),
      ),
    ));
  }
}