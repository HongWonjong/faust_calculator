class VisualizationService {
  // Firestore 데이터를 시각화에 맞게 변환
  List<Map<String, dynamic>> prepareMapData(Map<String, dynamic> background) {
    // 배경 데이터를 2D 맵에 맞게 가공
    return [
      {'x': 50, 'y': 50, 'label': '중앙 위치'}
    ]; // 임시 데이터
  }

  List<Map<String, dynamic>> prepareGraphData(
      Map<String, dynamic> groups, Map<String, dynamic> individuals) {
    // 그룹과 개인 데이터를 관계 그래프에 맞게 가공
    return [
      {'id': 'node1', 'label': '그룹1'},
      {'id': 'node2', 'label': '개인1'},
      {'source': 'node1', 'target': 'node2', 'label': '동맹'}
    ]; // 임시 데이터
  }
}