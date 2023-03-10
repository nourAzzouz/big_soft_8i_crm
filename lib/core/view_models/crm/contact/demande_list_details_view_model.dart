import 'package:big_soft_8i_crm/core/view_models/base_view_model.dart';
import 'package:big_soft_8i_crm/locator.dart';

import '../../../../ui/views/crm/contact/demande_details_view.dart';
import '../../../enums/view_states.dart';

import '../../../services/crm/demandes_list_service.dart';

class DemandeListDetailsViewModel extends BaseViewModel {
  final DemandesListService _contactService = locator<DemandesListService>();

  Future<dynamic> getCollab() async {
    changeState(ViewState.Busy);
    var demandesResult = await _contactService.getCollab();
    changeState(ViewState.Idle);
    return demandesResult;
  }

  Future<dynamic> getFunction() async {
    changeState(ViewState.Busy);
    var demandesResult = await _contactService.getFunction();
    changeState(ViewState.Idle);
    return demandesResult;
  }

  Future<dynamic> getsup() async {
    changeState(ViewState.Busy);
    var demandesResult = await _contactService.getsup();
    changeState(ViewState.Idle);
    return demandesResult;
  }

  Future<dynamic> updateContact(
    SaveContactArgument saveContactArgument,
  ) async {
    changeState(ViewState.Busy);
    var addContactResult =
        await _contactService.updateProspectViewModel(saveContactArgument);
    changeState(ViewState.Idle);
    return addContactResult;
  }
}
