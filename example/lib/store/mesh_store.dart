import 'package:mobx/mobx.dart';
import 'package:nordic_nrf_mesh/nordic_nrf_mesh.dart';

part 'mesh_store.g.dart';

class MeshStore = MeshStoreBase with _$MeshStore;

abstract class MeshStoreBase with Store {
  @observable
  NordicNrfMesh nordicNrfMesh = NordicNrfMesh();

  @observable
  MeshManagerApi meshManagerApi;

  @action
  void createMeshManagerApi() async {
    meshManagerApi = await nordicNrfMesh.createMeshManagerApi();
  }
}
