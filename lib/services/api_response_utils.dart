String buildApiSuccessMessage(Map<String, dynamic> responseData) {
  final parts = <String>[];

  final success = responseData['success'];
  if (success is String && success.trim().isNotEmpty) {
    parts.add(success.trim());
  }

  final rowsUpdated = responseData['rows_updated'];
  if (rowsUpdated != null) {
    parts.add('Linhas atualizadas: $rowsUpdated');
  }

  final notUpdated = responseData['not_updated'];
  if (notUpdated is List && notUpdated.isNotEmpty) {
    parts.add('Não atualizados: ${notUpdated.length}');
  }

  if (parts.isEmpty) {
    return 'Operação concluída.';
  }

  return parts.join(' • ');
}
