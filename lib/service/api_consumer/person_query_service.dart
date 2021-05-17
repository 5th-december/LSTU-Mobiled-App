import 'package:lk_client/model/listed_response.dart';
import 'package:lk_client/model/person/person.dart';
import 'package:lk_client/model/person/personal_data.dart';
import 'package:lk_client/model/person/profile_picture.dart';
import 'package:lk_client/error_handler/component_error_handler.dart';
import 'package:lk_client/model/authentication/api_key.dart';
import 'package:lk_client/service/authentication_extractor.dart';
import 'package:lk_client/service/http_service.dart';
import 'package:lk_client/state/consuming_state.dart';

class PersonQueryService {
  final ComponentErrorHandler apiErrorHandler;
  final AuthenticationExtractor authenticationExtractor;
  final ApiEndpointConsumer apiEndpointConsumer;

  ApiKey get accessKey => this.authenticationExtractor.getAuthenticationData();

  PersonQueryService(this.apiEndpointConsumer, this.authenticationExtractor,
      this.apiErrorHandler);

  Stream<ConsumingState<Person>> getPersonProperties(String person) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/person',
          <String, String>{'p': person},
          this.accessKey.token);

      if (response.status == 200) {
        Person person = Person.fromJson(response.body);
        yield ConsumingReadyState<Person>(person);
      } else {
        throw apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Person>(error: e);
    }
  }

  Stream<ConsumingState<Person>> getCurrentPersonIdentifier() async* {
    try {
      HttpResponse response = await this
          .apiEndpointConsumer
          .get('/api/v1/whoami', {}, this.accessKey.token);

      if (response.status == 200) {
        Person person = Person.fromJson(response.body);
        yield ConsumingReadyState<Person>(person);
      } else {
        throw apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<Person>(error: e);
    }
  }

  Stream<ConsumingState<ProfilePicture>> getPersonProfilePicture(
      String person, String size) async* {
    try {
      HttpResponse response = await this.apiEndpointConsumer.get(
          '/api/v1/person/pic',
          <String, String>{'p': person, 'size': size},
          this.accessKey.token);

      if (response.status == 200) {
        ProfilePicture pictureData = ProfilePicture.fromJson(response.body);
        yield ConsumingReadyState<ProfilePicture>(pictureData);
      } else {
        throw apiErrorHandler.apply(response.body);
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ProfilePicture>(error: e);
    }
  }

  Stream<ConsumingState<ListedResponse<Person>>> getPersonList
    (String query, String count, String offset) async* {
    Map<String, dynamic> queryParams = <String, dynamic>{};

    if(query != null) {
      queryParams['q'] = query;
    }

    if(count != null && offset != null) {
      queryParams['c'] = count;
      queryParams['of'] = offset;
    }

    try {
      HttpResponse response = await this.apiEndpointConsumer.get('/api/v1/person/list', 
        queryParams, this.accessKey.token);

      if(response.status == 200) {
        ListedResponse<Person> personList = ListedResponse.fromJson(response.body, Person.fromJson);
        yield ConsumingReadyState<ListedResponse<Person>>(personList);
      } else {
        yield ConsumingErrorState<ListedResponse<Person>>(error: this.apiErrorHandler.apply(response.body));
      }
    } on Exception catch (e) {
      yield ConsumingErrorState<ListedResponse<Person>>(error: e);
    }
  }

  Future<bool> editPersonProfile(PersonalData updatedProfileData) async {
    Map<String, dynamic> updateProfileSerialized = updatedProfileData.toJson();

    HttpResponse response = await this.apiEndpointConsumer.post(
        '/api/v1/person/props', {}, updateProfileSerialized, this.accessKey.token);

    if (response.status == 200) {
      return true;
    }

    throw this.apiErrorHandler.apply(response.body);
  }
}
