import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../ui/views/crm/compte/demande_Compte_details_view.dart';
import '/core/constants/constants.dart';
import '/core/models/demandes_compte_model.dart';
import 'package:http/http.dart' as http;

class DemandesCompteListService {
  Future<dynamic> getDemandes(int startIndex, int fetchLimit) async {
    var response;
    try {
      response = await http.post(
        Uri.parse("${Constants.baseURL}/${Constants.appName}/CompteCRMAction"),
        headers: <String, String>{
          "Cookie": Constants.sessionId,
        },
        body: {
          "start": startIndex.toString(),
          "limit": fetchLimit.toString(),
          "sort": "",
          "dir": "ASC",
          "action": "select",
          "code": "",
          "CGrp": "",
        },
      ).timeout(const Duration(seconds: 50));
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (response.contentLength == 0) {
      return 0;
    }
    var demandesResponse = DemandesCompteListResults.fromJson(
      json.decode(response.body),
    );
    return demandesResponse.results;
  }

  Future<dynamic> updateCompteViewModel(
    SaveCompteArgument saveCompteArgument,
  ) async {
    var response;
    try {
      response = await http.post(
          Uri.parse("${Constants.baseURL}/CompteCRMAction"),
          headers: <String, String>{
            "Cookie": Constants.sessionId,
          },
          body: {
            "action": "update",
            "PrecMtDevise": "",
            "CodeTiers": saveCompteArgument.code,
            "NomTiers": saveCompteArgument.nomCompteText,
            "Telephone": saveCompteArgument.telephoneText,
            "Fax": "",
            "AutreTel": "",
            "Email": saveCompteArgument.mailText,
            "Proprietaire": saveCompteArgument.propritaireText,
            "Note": saveCompteArgument.descriptionText,
            "CodeActivite": "",
            "LibActivite": "",
            "RevenuAnnuel": saveCompteArgument.revenueText,
            "Web": "",
            "AutreMail": "",
            "FilialeDe": "",
            "LFilialeDe": "",
            "Effectif": saveCompteArgument.effictifeText,
            "CodeSecteur": "",
            "LibSecteur": saveCompteArgument.secteurText,
            "TypeCompte": "",
            "CodeCollab": "",
            "NomCollab": "",
            "PrenomCollab": "",
            "CodeDevise": "",
            "IsLocal": "",
            "Adresse": "",
            "BPFact": "",
            "Ville": "",
            "Pays": "",
            "CodePostal": "",
            "AdrLiv": "",
            "BPLiv": "",
            "VilleLiv": "",
            "PaysLiv": "",
            "CodePostalLiv": "",
            "ext-comp-1785": "Contient",
            "ext-comp-1783": "",
            "filterValue": "",
          });
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (response.contentLength == 0) {
      return 0;
    }

    var isAddContactSuccess = json.decode(response.body)["success"];
    if (isAddContactSuccess) {
      print(isAddContactSuccess);
      return isAddContactSuccess;
    } else {
      var addContactbackMessage = json.decode(response.body)["feedback"];
      print(addContactbackMessage);
      return addContactbackMessage;
    }
  }

  Future<dynamic> deleteDemande(String code) async {
    var response;
    try {
      response = await http.post(
        Uri.parse("${Constants.baseURL}/${Constants.appName}/ContactCRMAction"),
        headers: <String, String>{
          "Cookie": Constants.sessionId,
        },
        body: {
          "action": "delete",
          "CodeCtc": code,
        },
      ).timeout(const Duration(seconds: 30));
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (response.contentLength == 0) {
      return 0;
    }
    var isDeleteSuccess = json.decode(response.body)["success"];
    if (isDeleteSuccess) {
      return isDeleteSuccess;
    } else {
      var deleteFeedbackMessage = json.decode(response.body)["feedback"];
      return deleteFeedbackMessage;
    }
  }

  Future<dynamic> getSect() async {
    var response;
    try {
      response = await http.post(
        Uri.parse("${Constants.baseURL}/base/SecteurAction"),
        headers: <String, String>{
          "Cookie": Constants.sessionId,
        },
        body: {
          "start": "",
          "limit": "",
          "sort": "CodeSecteur",
          "dir": "ASC",
          "action": "select",
          "useCache": "false",
          "Filter": "",
          "CGrp": ""
        },
      ).timeout(const Duration(seconds: 50));
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (response.contentLength == 0) {
      return 0;
    }
    var demandesResponse = SecListResults.fromJson(
      json.decode(response.body),
    );
    return demandesResponse.results;
  }

  Future<dynamic> getAssg() async {
    var assgresponse;
    try {
      assgresponse = await http.post(
        Uri.parse("${Constants.baseURL}/crm/CollaborateurAction"),
        headers: <String, String>{
          "Cookie": Constants.sessionId,
        },
        body: {
          "start": "0",
          "limit": "25",
          "sort": "CodeCollab",
          "dir": "ASC",
          "action": "select",
          "useCache": "false",
          "Filter": "",
          "CGrp": ""
        },
      ).timeout(const Duration(seconds: 50));
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (assgresponse.contentLength == 0) {
      return 0;
    }
    var demandesResponse = AssgCollabListResults.fromJson(
      json.decode(assgresponse.body),
    );
    return demandesResponse.results;
  }

  Future<dynamic> getdev() async {
    var devresponse;
    try {
      devresponse = await http.post(
        Uri.parse("${Constants.baseURL}/DeviseAction"),
        headers: <String, String>{
          "Cookie": Constants.sessionId,
        },
        body: {
          "sort": "",
          "dir": "ASC",
          "action": "select",
          "useCache": "true"
        },
      ).timeout(const Duration(seconds: 50));
    } on TimeoutException catch (_) {
      return "Cette requette a pris un temps inattendu";
    } on SocketException catch (_) {
      return "Vérifier la configuration de votre réseau";
    }
    if (devresponse.contentLength == 0) {
      return 0;
    }
    var demandesResponse = DevListResults.fromJson(
      json.decode(devresponse.body),
    );
    return demandesResponse.results;
  }
}
