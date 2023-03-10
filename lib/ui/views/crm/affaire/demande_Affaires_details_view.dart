import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/enums/view_states.dart';
import '../../../../core/models/demandes_Affaire_list_model.dart';
import '../../../../core/view_models/crm/affaire/demande_affaire_details_view_model.dart';
import '../../../shared/size_config.dart';
import '../../../widgets/contact_support_alert_view.dart';
import '../../../widgets/custom_dropdown_field.dart';
import '../../../widgets/custom_flutter_toast.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/loading_error_view.dart';
import '../../base_view.dart';

class DemandeAffaireDetailsView extends StatefulWidget {
  final demandeAffaireDetailsViewArguments;

  const DemandeAffaireDetailsView(
      {Key? key, this.demandeAffaireDetailsViewArguments})
      : super(key: key);

  @override
  State<DemandeAffaireDetailsView> createState() =>
      _DemandeAffaireDetailsViewState();
}

class _DemandeAffaireDetailsViewState extends State<DemandeAffaireDetailsView> {
  late List<RelListModel> relResultsList;
  var relValue;
  List<DropdownMenuItem<Object?>> _dropdownTestItems = [];

  late GlobalKey<ScaffoldState> _scaffoldKey;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _numeroTextFormFieldController;
  late TextEditingController _nomTextFormFieldController;
  late TextEditingController _dateTextFormFieldController;
  late TextEditingController _typeTextFormFieldController;
  late TextEditingController _montantTextFormFieldController;
  late TextEditingController _nomTiersTextFormFieldController;
  late TextEditingController _probaliteTextFormFieldController;
  late TextEditingController _suivantTextFormFieldController;
  late TextEditingController _descriptionTextFormFieldController;

  int _indexToStartPaginatingFrom = 25;
  int _dataFetchLimit = 25;

  late FToast fToast;
  static const toastMessage = "Impossible de modifier ce champ";

  late String codeDoc;
  late String codeParamProj;
  late String factureDepassement;
  late String typeProjet;
  late String type;
  late String montAtt;
  late String montantDepassement;

  late DemandesAffaireListModel affaireDetails;
  bool dataFinishLoading = true;
  bool dataLoadingError = false;
  late String dataLoadingErrorMessage;

  //for dropdownmenu
  bool _canShowButton = true;
  bool _offstage = true;

  void hideWidget() {
    setState(() {
      _canShowButton = !_canShowButton;
      _offstage = !_offstage;
    });
  }

  bool _canShowButton2 = true;
  bool _offstage2 = true;

  void hideWidget2() {
    setState(() {
      _canShowButton2 = !_canShowButton2;
      _offstage2 = !_offstage2;
    });
  }

  // Initial Selected Value
  String dropdownvalue = '';
  var types = [
    'Item 1',
    'Item 2',
  ];

  @override
  void initState() {
    super.initState();

    relResultsList = [];
    // List of items in our dropdown menu

    _scaffoldKey = GlobalKey<ScaffoldState>();
    _formKey = GlobalKey<FormState>();
    _numeroTextFormFieldController = TextEditingController();
    _nomTextFormFieldController = TextEditingController();
    _dateTextFormFieldController = TextEditingController();
    _typeTextFormFieldController = TextEditingController();
    _montantTextFormFieldController = TextEditingController();
    _nomTiersTextFormFieldController = TextEditingController();
    _probaliteTextFormFieldController = TextEditingController();
    _suivantTextFormFieldController = TextEditingController();
    _descriptionTextFormFieldController = TextEditingController();
    /*
    _numeroTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.numero.toString();
    _nomTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.nom.toString();
    _dateTextFormFieldController.text =  widget.demandeAffaireDetailsViewArguments!.date.toString();
    _montantTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.montant.toString();
    _typeTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.typePros.toString();
    _nomTiersTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.nomTiers.toString();
    _probaliteTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.prob.toString();
    _suivantTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.suivant.toString();
    _descriptionTextFormFieldController.text = widget.demandeAffaireDetailsViewArguments!.desc.toString();
    */

    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    _numeroTextFormFieldController.dispose();
    _nomTextFormFieldController.dispose();
    _dateTextFormFieldController.dispose();
    _typeTextFormFieldController.dispose();
    _montantTextFormFieldController.dispose();
    _nomTiersTextFormFieldController.dispose();
    _probaliteTextFormFieldController.dispose();
    _suivantTextFormFieldController.dispose();
    _descriptionTextFormFieldController.dispose();
    super.dispose();
  }

  onPressAction(DemandeAffaireDetailsViewModel viewModel, scaffoldstate) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //if (_formKey.currentState!.validate()) {
    var addProspectResult = await viewModel.updateAffaire(SaveAffaireArgument(
        num: _numeroTextFormFieldController.text,
        nomAffaire: _nomTextFormFieldController.text,
        montant: _montantTextFormFieldController.text,
        dateE: _dateTextFormFieldController.text,
        prob: _probaliteTextFormFieldController.text,
        rel: _nomTiersTextFormFieldController.text,
        type: _typeTextFormFieldController.text,
        description: _descriptionTextFormFieldController.text));
    //isAddProspectSuccess = true;
    //print(addProspectResult);
    /*
      if (addContactResult is bool) {
        setState(() {
          return isAddContactSuccess = true;
        });
      } else if (addContactResult is int) {
        showDialog(
          context: context,
          barrierDismissible: false,
          child: WillPopScope(
            onWillPop: () async => false,
            child: ContactSupportAlertView(),
          ),
        );
      } else {
        scaffoldstate.showSnackBar(
          SnackBar(
            content: Text(
              removeAllHtmlTags(addContactResult),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
   
   
   */
    //}
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DemandeAffaireDetailsViewModel>(
      onModelReady: (viewModel) => getAffaireDetails(viewModel, context),
      builder: (context, viewModel, child) => Scaffold(
        key: _scaffoldKey,
        body: dataFinishLoading
            ? SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.heightMultiplier * 6),
                      Form(
                        key: _formKey,
                        child: AbsorbPointer(
                          absorbing: viewModel.state == ViewState.Busy,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: _numeroTextFormFieldController,
                                inputLabel: "N?? Affaire",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: true,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              CustomTextField(
                                controller: _nomTextFormFieldController,
                                inputLabel: "Nom affaire",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              CustomTextField(
                                controller: _montantTextFormFieldController,
                                inputLabel: "Montant",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              CustomTextField(
                                controller: _dateTextFormFieldController,
                                inputLabel: "Date Ech??ance",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              CustomTextField(
                                controller: _probaliteTextFormFieldController,
                                inputLabel: "Probabilit??",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),

                              ///if the show button is false
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                              !_canShowButton
                                  ? const SizedBox.shrink()
                                  : CustomTextField(
                                      controller:
                                          _nomTiersTextFormFieldController,
                                      inputLabel: "Relatif ?? ",
                                      helperText: " ",
                                      style: TextStyle(color: Colors.grey[600]),
                                      readOnly: false,
                                      enabled: true,
                                      filled: true,
                                      onTapAction: () {
                                        hideWidget();
                                        //_number();
                                      },
                                    ),
                              /*SizedBox(
                                      height: SizeConfig.heightMultiplier * 3),*/
                              Offstage(
                                offstage: _offstage,
                                child: CustomDropdownField(
                                  labelText: "Relatif ?? ",
                                  value: relValue,
                                  items: relResultsList.map((value) {
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(value.npRel),
                                    );
                                  }).toList(),
                                  onChangedAction: (value) {
                                    setState(() {
                                      relValue = value!;
                                    });
                                  },
                                  validator: (value) => dropdownFieldValidation(
                                    value,
                                    "Selectionne une fonction",
                                  ),
                                ),
                              ),

                              SizedBox(height: SizeConfig.heightMultiplier * 2),

                              ///if the show button is false
                              !_canShowButton2
                                  ? const SizedBox.shrink()
                                  : CustomTextField(
                                      controller: _typeTextFormFieldController,
                                      inputLabel: "Type",
                                      helperText: " ",
                                      style: TextStyle(color: Colors.grey[600]),
                                      readOnly: false,
                                      enabled: true,
                                      filled: true,
                                      onTapAction: () {
                                        hideWidget2();
                                      },
                                    ),
                              /*SizedBox(
                                      height: SizeConfig.heightMultiplier * 3),*/
                              Offstage(
                                  offstage: _offstage2,
                                  child: CustomDropdownField(
                                    labelText: "Type ",
                                    items: <String>[
                                      'Client ??xistant',
                                      'Nouveau Client'
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChangedAction: (value) {
                                      setState(() {
                                        value = value!;
                                      });
                                    },
                                    validator: (value) =>
                                        dropdownFieldValidation(
                                      value,
                                      "Selectionne une fonction",
                                    ),
                                  )),

                              SizedBox(height: SizeConfig.heightMultiplier * 2),

                              /*SizedBox(height: SizeConfig.heightMultiplier * 2),
                              CustomTextField(
                                controller: _suivantTextFormFieldController,
                                inputLabel: "Suivant",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                onTapAction: () =>
                                    showToast(fToast, toastMessage, context),
                              ),*/

                              CustomTextField(
                                controller: _descriptionTextFormFieldController,
                                inputLabel: "Description",
                                helperText: " ",
                                style: TextStyle(color: Colors.grey[600]),
                                readOnly: false,
                                enabled: true,
                                filled: true,
                                /*onTapAction: () =>
                                    showToast(fToast, toastMessage, context),*/
                              ),
                              SizedBox(height: SizeConfig.heightMultiplier * 2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : dataLoadingError
                ? SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await getAffaireDetails(viewModel, context);
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          child: Center(
                            child: LoadingErrorView(
                              imageURL: "assets/images/error.png",
                              errorMessage: dataLoadingErrorMessage,
                            ),
                          ),
                          height: SizeConfig.heightMultiplier * 77,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            await onPressAction(
              viewModel,
              _scaffoldKey.currentState,
            );
          },
        ),
      ),
    );
  }

  String? dropdownFieldValidation(value, validationMessage) =>
      value == null ? validationMessage : null;

  Future<void> getAffaireDetails(
      DemandeAffaireDetailsViewModel viewModel, BuildContext context) async {
    var affaireDetailsResult = await viewModel
        .getAffaireDetails("${widget.demandeAffaireDetailsViewArguments}");

    var relResults = await viewModel.getRel();
    if (affaireDetailsResult is DemandesAffaireListModel) {
      setState(
        () {
          dataFinishLoading = true;
          relResultsList = relResults;
          _numeroTextFormFieldController.text =
              affaireDetailsResult.numero.toString();
          _nomTextFormFieldController.text =
              affaireDetailsResult.nom.toString();
          _dateTextFormFieldController.text =
              affaireDetailsResult.date.toString();
          _montantTextFormFieldController.text =
              affaireDetailsResult.montant.toString();
          _typeTextFormFieldController.text =
              affaireDetailsResult.typePros.toString();
          _nomTiersTextFormFieldController.text =
              affaireDetailsResult.nomTiers.toString();
          _probaliteTextFormFieldController.text =
              affaireDetailsResult.prob.toString();
          _suivantTextFormFieldController.text =
              affaireDetailsResult.suivant.toString();
          _descriptionTextFormFieldController.text =
              affaireDetailsResult.desc.toString();
        },
      );
    } else if (affaireDetailsResult is int) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: const ContactSupportAlertView(),
          );
        },
      );
    } else {
      setState(() {
        dataLoadingErrorMessage = affaireDetailsResult;
        dataLoadingError = true;
      });
    }
  }
}

DropdownMenuItem<String> buildMenuItem(String item) =>
    DropdownMenuItem(value: item, child: Text(item));

class SaveAffaireArgument {
  final String num;
  final String nomAffaire;
  final String montant;
  final String dateE;
  final String prob;
  final String rel;
  final String type;
  final String description;

  SaveAffaireArgument({
    required this.num,
    required this.nomAffaire,
    required this.montant,
    required this.dateE,
    required this.prob,
    required this.rel,
    required this.type,
    required this.description,
  });
}

/*
class DemandeAffaireDetailsView extends StatelessWidget {
  final DemandesAffaireListModel? demandeAffaireDetailsViewArguments;
  final DemandesAffaireListViewModel? viewModel;

  const DemandeAffaireDetailsView(
      {Key? key, this.demandeAffaireDetailsViewArguments, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(demandeAffaireDetailsViewArguments!.nom),
          ),
          body: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Num Affaire :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text('' +
                                demandeAffaireDetailsViewArguments!.numero))
                      ],
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Libelle :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('' + demandeAffaireDetailsViewArguments!.nom)
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Date Ech??ance :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('' + demandeAffaireDetailsViewArguments!.date)
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Type:'),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('' + demandeAffaireDetailsViewArguments!.typePros)
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Montant:'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text('' +
                                demandeAffaireDetailsViewArguments!.montant))
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Relatif ?? :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text('' +
                                demandeAffaireDetailsViewArguments!.nomTiers))
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Probalit??:'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text(
                                '' + demandeAffaireDetailsViewArguments!.prob))
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Suivant :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text('' +
                                demandeAffaireDetailsViewArguments!.suivant))
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan[500]!,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        const Text('Description :'),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Text(
                                '' + demandeAffaireDetailsViewArguments!.desc))
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
            ],
          )),
    );
  }
}
*/